import { ArcButton, ArcButtonOptions, ArcButtonPosition, ArcButtonStyleMode } from '@kit.ArkUI';

@Component
export struct BackButton {
  @Consume('pathStack') pathStack: NavPathStack;

  build() {
    // Attempting to match the required @Require options pattern
    ArcButton({
      options: {
        label: 'Back',
        position: ArcButtonPosition.TOP_EDGE,
        styleMode: ArcButtonStyleMode.EMPHASIZED_LIGHT
      }
    })
      .onClick(() => {
        this.pathStack.pop();
      })
  }
}
