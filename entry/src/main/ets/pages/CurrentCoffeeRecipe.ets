import { Recipe, RecipeStep } from '../model/RecipeModel';
import { RecipeService } from '../service/RecipeService';
import { CoffeeConstants } from '../common/Constants';
import { BackButton } from '../view/BackButton';
import { vibrator, sensor } from '@kit.SensorServiceKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Component
export struct CurrentCoffeeRecipe {
  @Prop recipeId: string;
  @State currentStepIndex: number = 0;
  @State timeLeft: number = 0;
  @State isTimerRunning: boolean = false;
  @State recipe: Recipe | undefined = undefined;
  @Consume('pathStack') pathStack: NavPathStack;

  private timerId: number = -1;
  watchSize: string = CoffeeConstants.WATCH_SIZE;

  aboutToAppear() {
    this.recipe = RecipeService.getInstance().getRecipeById(this.recipeId);
    this.resetTimer();
    // Voice command simulation / preparation would go here if SpeechRecognizer was fully accessible
  }

  aboutToDisappear() {
    this.stopTimer();
  }

  resetTimer() {
    this.stopTimer();
    if (this.recipe && this.recipe.steps[this.currentStepIndex].timerSeconds) {
      this.timeLeft = this.recipe.steps[this.currentStepIndex].timerSeconds!;
    } else {
      this.timeLeft = 0;
    }
  }

  startTimer() {
    if (this.timeLeft > 0 && !this.isTimerRunning) {
      this.isTimerRunning = true;
      this.timerId = setInterval(() => {
        if (this.timeLeft > 0) {
          this.timeLeft--;
        } else {
          this.stopTimer();
          this.vibrate('long');
        }
      }, 1000);
    }
  }

  stopTimer() {
    if (this.timerId !== -1) {
      clearInterval(this.timerId);
      this.timerId = -1;
    }
    this.isTimerRunning = false;
  }

  vibrate(type: 'short' | 'long') {
    try {
      vibrator.startVibration({
        type: 'time',
        duration: type === 'short' ? 200 : 1000
      }, {
        id: 0,
        usage: 'alarm'
      });
    } catch (err) {
      console.error('Vibration failed', err);
    }
  }

  getStepColor(): string {
    if (!this.recipe) return CoffeeConstants.TEXT_COLOR;
    const step = this.recipe.steps[this.currentStepIndex];
    switch (step.type) {
      case 'espresso': return CoffeeConstants.ESPRESSO_COLOR;
      case 'milk': return CoffeeConstants.MILK_COLOR;
      case 'water': return CoffeeConstants.WATER_COLOR;
      default: return CoffeeConstants.TEXT_COLOR;
    }
  }

  build() {
    NavDestination() {
      if (this.recipe) {
        Stack() {
          // Progress Ring (simulated with Progress component)
          Progress({
            value: this.currentStepIndex + 1,
            total: this.recipe.steps.length,
            type: ProgressType.Ring
          })
            .width('100%')
            .height('100%')
            .color(this.getStepColor())
            .backgroundColor('#333333')
            .style({ strokeWidth: 10 })

          BackButton()

          Column({ space: 10 }) {
            Text(`${this.recipe.name}`)
              .fontSize(14)
              .fontColor(CoffeeConstants.ACCENT_COLOR)

            Text(`Step ${this.currentStepIndex + 1} of ${this.recipe.steps.length}`)
              .fontSize(12)
              .fontColor(CoffeeConstants.WHITE)

            Text(this.recipe.steps[this.currentStepIndex].description)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Center)
              .fontColor(this.getStepColor())
              .padding({ left: 40, right: 40 })

            if (this.timeLeft > 0 || this.isTimerRunning) {
              Text(`${this.timeLeft}s`)
                .fontSize(24)
                .fontColor(CoffeeConstants.ACCENT_COLOR)
                .onClick(() => {
                  if (this.isTimerRunning) this.stopTimer();
                  else this.startTimer();
                })

              Button(this.isTimerRunning ? 'Pause' : 'Start Timer')
                .fontSize(12)
                .backgroundColor(CoffeeConstants.ACCENT_COLOR)
                .fontColor(CoffeeConstants.PRIMARY_COLOR)
                .onClick(() => {
                  if (this.isTimerRunning) this.stopTimer();
                  else this.startTimer();
                })
            }

            // Voice command hint
            Text('Say "Next" to continue')
              .fontSize(10)
              .fontColor(CoffeeConstants.WHITE)
              .opacity(0.6)
              .margin({ top: 5 })

            Row({ space: 20 }) {
              Button('Prev')
                .enabled(this.currentStepIndex > 0)
                .backgroundColor('#444444')
                .onClick(() => {
                  if (this.currentStepIndex > 0) {
                    this.currentStepIndex--;
                    this.resetTimer();
                    this.vibrate('short');
                  }
                })

              Button(this.currentStepIndex < this.recipe.steps.length - 1 ? 'Next' : 'Done')
                .backgroundColor(CoffeeConstants.ACCENT_COLOR)
                .fontColor(CoffeeConstants.PRIMARY_COLOR)
                .onClick(() => {
                  if (this.currentStepIndex < this.recipe.steps.length - 1) {
                    this.currentStepIndex++;
                    this.resetTimer();
                    this.vibrate('short');
                  } else {
                    this.pathStack.pushPathByName('ReadyCoffee', this.recipeId);
                  }
                })
            }
            .margin({ top: 10 })
          }
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        }
        .width(this.watchSize)
        .height(this.watchSize)
        .backgroundColor(CoffeeConstants.PRIMARY_COLOR)
      }
    }
    .hideTitleBar(true)
    .hideBackButton(true)
  }
}
