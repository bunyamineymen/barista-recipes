import { ArcButton, ArcButtonOptions, ArcButtonPosition, ArcButtonStyleMode } from '@kit.ArkUI';

@Component
export struct BackButton {
  @Consume('pathStack') pathStack: NavPathStack;

  build() {
    ArcButton({
      label: 'Back',
      position: ArcButtonPosition.TOP_EDGE,
      styleMode: ArcButtonStyleMode.NORMAL
    })
      .onClick(() => {
        this.pathStack.pop();
      })
  }
}
