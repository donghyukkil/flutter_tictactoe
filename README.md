<p align="center">
     <img src="./assets/home_screen.png" width="300" height="300">
</p>

# 목차

- [프로젝트 소개](#프로젝트-소개)
- [프로젝트 관심사](#프로젝트-관심사)
- [주요 기능](#주요-기능)
- [기술스택](#기술스택)
- [연락처](#연락처)

<br>

# 프로젝트 소개
- Flutter Tic Tac Toe

  <p align="center">
     <img src="https://github.com/donghyukkil/flutter_tictactoe/assets/124029691/e9871b3e-826a-4043-87b7-467052657bcf" width="200" height="350">
  </p>


<br>

# 프로젝트 구조

```
├─ lib
│  ├─ controllers
│  │  ├─ game_controller.dart
│  │  └─ game_history_provider.dart
│  ├─ main.dart
│  ├─ models
│  │  └─ game_model.dart
│  └─ views
│     ├─ game
│     │  └─ game_screen.dart
│     ├─ game_history
│     │  └─ game_history_screen.dart
│     ├─ game_settings
│     │  └─ game_settings_screen.dart
│     └─ home
│        └─ home_screen.dart

```

<br>

- Model: 게임의 상태, 게임 보드의 크기, 승리 조건, 플레이어 정보 등을 포함합니다.
- View: 게임 보드와 설정 화면 등 사용자가 상호작용하는 부분을 담당합니다.
  - GameScreen은 GameModel 인스턴스를 사용하여 렌더링.
- Controller: 사용자의 입력을 받아 모델을 업데이트하고, 뷰에 변경 사항을 알립니다.
  - GameController: GameModel 인스턴스를 통해 게임의 상태를 관리합니다. 사용자의 입력(예: 타일 선택)에 따라 GameModel의 상태를 업데이트합니다.
- Provider 사용: Provider를 사용하여 GameController와 같은 상태 관리 객체를 앱 전반에 걸쳐 공유합니다.

<br>

- 새 게임 시작
  - GameModel 생성: 사용자가 새 게임을 시작할 때, GameModel의 인스턴스가 생성됩니다. 이때, 게임의 기본 설정(예: 보드 크기, 승리 조건, 플레이어 마크와 색상 등)이 생성자를 통해 초기화됩니다.
  - GameScreen 이동: 앱은 GameScreen으로 화면을 전환되며 실제 게임이 시작되고 게임 로직과 상태는 GameModel 인스턴스에 의해 관리됩니다.
  - GameController는 GameModel의 initialModel이 제공되지 않은 경우, GameScreen은 새로운 게임을 위해 제공되고 사용자의 입력에 따라 게임을 진행합니다.

- 이전 게임 기록 불러오기
  - GameModel.fromHistory 생성: 사용자가 이전 게임 기록을 불러올 때, GameModel.fromHistory 팩토리 생성자를 사용하여 GameModel의 인스턴스가 생성됩니다. 이전 게임의 상태(예: 보드 상태, 수의 순서 등)를 기반으로 GameModel 인스턴스를 초기화합니다.
  - GameScreen에 전달: 생성된 GameModel 인스턴스는 GameScreen으로 전달됩니다. GameScreen에서는 didChangeDependencies를 통해 게임 컨트롤러 인스턴스를 가져오고, 이전 게임의 모델을 기반으로 화면을 구성합니다.

# 프로젝트 관심사

  ### initState vs didChangeDependencies

  - 히스토리 관리나 새로운 게임을 위해 GameScreen을 재사용하면 좋겠다고 생각했습니다. 적절한 모델로 초기화하기 위해서, 비동기 작업을 위젯이 렌더링 되는 시점 이전에 완료될 필요가 있었고 이를 initState 내부에 필요한 로직을 작성했습니다. 하지만 히스토리에서 게임 스크린을 불러올 때 이전 화면이 남아 있어서 정상적으로 모델이 변경 되고 그에 따라서 UI가 렌더링 되지 않는 문제가 발생했습니다. initState 메소드는 위젯의 생명주기에서 단 한 번, 위젯이 생성될 때 호출되며 위젯의 상태를 초기화하기 위해 사용됩니다.하지만 뒤로 가기를 클릭하여 사용자가 이전 화면으로 돌아가면 위젯 트리에서 위젯이 제거되었다가 다시 추가되는 경우 initState는 다시 호출되지 않습니다.

  - didChangeDependencies 메소드는 initState 이후에 호출되며, 위젯의 의존성이 변경될 때마다 반복적으로 호출될 수 있습니다. 따라서 이전 게임의 상태를 복원하거나 새로운 게임의 초기 상태를 설정하는 로직을 didChangeDependencies 내에 구현하면, 사용자 액션에 따라 필요한 모델을 인스턴스화해서 게임 스크린을 렌더링하게 됩니다. Provider로부터 받는 데이터가 변경되면 didChangeDependencies가 호출되어 위젯이 새로운 데이터에 맞게 자신을 업데이트할 수 있습니다.

 <br>

# 주요 기능

 - 게임 셋팅

    <p align="center">
     <img src="https://github.com/donghyukkil/flutter_tictactoe/assets/124029691/e2ae01ba-b92c-462c-90fa-8cd9e1d41853" width="200" height="350">
    </p>

  - 랜덤 마크

    <p align="center">
     <img src="https://github.com/donghyukkil/flutter_tictactoe/assets/124029691/e20ff344-9b23-4bb5-8377-deeeba153efa" width="200" height="350">
    </p>

  - 무르기 기능

    <p align="center">
     <img src="https://github.com/donghyukkil/flutter_tictactoe/assets/124029691/b4e32727-2149-4d8f-9a12-aa154c0b4961" width="200" height="350">
    </p>


# 기술스택

- Front-end:
  - Dart, Flutter, Provider, Mockito

<br>

# 연락처

<table>
  <tr>
    <td align="center">
      <a href="https://github.com/donghyukkil">
        <img src="https://avatars.githubusercontent.com/u/124029691?v=4" alt="길동혁 프로필" width="100px" height="100px" />
      </a>
    </td>
  </tr>
  <tr>
    <td>
      <ul>
        <li><a href="https://github.com/donghyukkil">길동혁</a></li>
		    <li>asterism90@gmail.com</li>
	    </ul>
    </td>
  </tr>
</table>




