import { vibrator, sensor } from '@kit.SensorServiceKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { CoffeeConstants } from '../common/Constants';
import { RecipeService } from '../service/RecipeService';

@Component
export struct ReadyCoffee {
  @Prop recipeId: string;
  @State isMixing: boolean = false;
  @State mixingProgress: number = 0;
  @Consume('pathStack') pathStack: NavPathStack;

  watchSize: string = CoffeeConstants.WATCH_SIZE;
  private mixingThreshold: number = 15; // Acceleration threshold
  private targetMixingPoints: number = 50; // Points to complete mixing

  aboutToAppear(): void {
    this.startVibrate();
    this.startMixingDetection();
    this.saveToHistory();
  }

  aboutToDisappear(): void {
    this.stopVibrate();
    this.stopMixingDetection();
  }

  saveToHistory() {
    const recipe = RecipeService.getInstance().getRecipeById(this.recipeId);
    if (recipe) {
      RecipeService.getInstance().addBrewHistory({
        recipeId: recipe.id,
        recipeName: recipe.name,
        timestamp: Date.now(),
        durationSeconds: recipe.totalTimeMinutes * 60 // Simplified
      });
    }
  }

  startVibrate() {
    try {
      // Rhythmic vibration for mixing
      vibrator.startVibration({
        type: 'time',
        duration: 8000
      }, {
        id: 0,
        usage: 'alarm'
      });
    } catch (err) {
      console.error('Vibration failed', err);
    }
  }

  stopVibrate() {
    try {
      vibrator.stopVibration(vibrator.VibratorStopMode.VIBRATOR_STOP_MODE_TIME);
    } catch (err) {
      console.error('Stop vibration failed', err);
    }
  }

  startMixingDetection() {
    try {
      sensor.on(sensor.SensorId.ACCELEROMETER, (data: sensor.AccelerometerResponse) => {
        const acceleration = Math.sqrt(data.x * data.x + data.y * data.y + data.z * data.z);
        if (acceleration > this.mixingThreshold) {
          this.isMixing = true;
          if (this.mixingProgress < 100) {
            this.mixingProgress += 2;
          }
        } else {
          this.isMixing = false;
        }
      }, { interval: 100000000 }); // 100ms
    } catch (err) {
      console.error('Accelerometer failed', err);
    }
  }

  stopMixingDetection() {
    try {
      sensor.off(sensor.SensorId.ACCELEROMETER);
    } catch (err) {
      console.error('Stop accelerometer failed', err);
    }
  }

  build() {
    NavDestination() {
      Flex() {
        Column({ space: 20 }) {
          Text('ENJOY YOUR COFFEE!')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor(CoffeeConstants.ACCENT_COLOR)

          Image($r('app.media.coffee'))
            .width('40%')
            .fillColor(this.isMixing ? CoffeeConstants.ACCENT_COLOR : CoffeeConstants.WHITE)
            .scale({ x: this.isMixing ? 1.1 : 1.0, y: this.isMixing ? 1.1 : 1.0 })
            .animation({ duration: 200 })

          if (this.mixingProgress < 100) {
            Column({ space: 5 }) {
              Text('Shake to mix properly')
                .fontColor(CoffeeConstants.WHITE)
                .fontSize(14)

              Progress({ value: this.mixingProgress, total: 100, type: ProgressType.Linear })
                .width('60%')
                .color(CoffeeConstants.ACCENT_COLOR)
            }
          } else {
            Text('Perfectly Mixed!')
              .fontColor(CoffeeConstants.ACCENT_COLOR)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
          }

          Button('Done')
            .backgroundColor(CoffeeConstants.ACCENT_COLOR)
            .fontColor(CoffeeConstants.PRIMARY_COLOR)
            .margin({ top: 20 })
            .onClick(() => {
              this.pathStack.clear();
            })
        }
        .width(this.watchSize)
        .height(this.watchSize)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
      .backgroundColor(CoffeeConstants.PRIMARY_COLOR)
    }
    .hideTitleBar(true)
    .hideBackButton(true)
  }
}
