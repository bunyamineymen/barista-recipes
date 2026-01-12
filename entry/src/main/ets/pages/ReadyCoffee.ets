import { vibrator } from '@kit.SensorServiceKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Component
export struct ReadyCoffee {
  watchSize: string = '466px'

  aboutToAppear(): void {
    this.startVibrate()
  }

  startVibrate() {
    try {
      vibrator.startVibration({
        type: 'time',
        duration: 8000
      }, {
        id: 0,
        usage: 'alarm'
      }, (error: BusinessError) => {
        if (error) {
          console.error(`Failed to start vibration. Code: ${error.code}, message: ${error.message}`);
          return;
        }
        console.info('Succeed in starting vibration');
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      console.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
    }
  }

  onPageHide(): void {
    try {
      vibrator.stopVibration(vibrator.VibratorStopMode.VIBRATOR_STOP_MODE_TIME, (error: BusinessError) => {
        if (error) {
          console.error(`Failed to stop vibration. Code: ${error.code}, message: ${error.message}`);
          return;
        }
        console.info('Succeed in stopping vibration');
      })
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      console.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
    }
  }

  build() {
    NavDestination() {
      Flex() {
        Column({ space: 20 }) {
          Image($r('app.media.coffee')).width('40%').fillColor('#C6A575')

          Row({ space: 10 }) {
            Text('Please shake until the vibration stops').padding({ left: 4, bottom: 7 }).fontColor('#C6A575')
          }
        }
        .width(this.watchSize)
        .height(this.watchSize)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
      .backgroundColor('#5B3A1F')
    }
    .hideTitleBar(true)
    .hideBackButton(true)
  }
}


