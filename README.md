<img width="1200" src="https://github.com/user-attachments/assets/20e8a39a-78a1-4c88-bec4-3c84b7d257a5" />

# <img src="https://github.com/user-attachments/assets/4571f8fd-8b93-44ce-b1d6-48fac7655bad" height="40"/> ByeBoo
> 이별 후의 감정을 정리하고 극복하도록 돕는 감정 케어 서비스
<br/>

##  <img width="40" src="https://github.com/user-attachments/assets/404fe305-6805-4971-8599-440227ab5716" /> 서비스 소개

> `ByeBoo`는 이별의 감정을 맞춤형 퀘스트를 통해 정리하고, 감정 회복의 여정을 함께하는 감정 케어 앱입니다.
사용자는 자기 성찰형/행동 실천형 퀘스트를 선택하여 보리와 함께 감정을 직면하고 일상을 회복해나갑니다.

### ➊ 스플래시&온보딩
가입 직후 온보딩 과정을 통해 서비스의 세계관에 대해 안내 받습니다. 메인 캐릭터인 ‘보리’의 스토리를 들으며 서비스에 대한 이해도를 높일 수 있습니다.

### ➋ 정보 입력
닉네임 / 이별 후의 감정 상태 / 선호하는 퀘스트 스타일을 선택한 후, 입력한 정보에 맞는 이별 극복 여정을 안내받습니다.
*앱잼 구현 범위 내에서는 ‘퀘스트 스타일’만 고려해 여정을 제공합니다. 따라서 질문형-감정 직면 / 행동형-감정 정리 여정 2가지가 제공됩니다.

### ➌ 홈
홈에서 서비스의 메인 캐릭터인 ‘보리’를 만나볼 수 있으며, 보리가 해주는 위로와 응원의 한마디를 제공 받을 수 있습니다.
또한 퀘스트 및 전체 여정의 진행 상태를 한 눈에 확인할 수 있습니다.

### ➍ 퀘스트

하나의 이별 극복 여정은 총 5단계로 구성되며, 각 단계마다 6개의 퀘스트가 포함되어 있어 한 여정은 총 30개의 퀘스트로 이루어집니다.
퀘스트는 단계별로 점진적으로 설계되어 있어, 사용자는 이를 따라가며 감정과 상황을 직면하고 정리해 나가는 과정을 경험하게 됩니다.

 > 📝 **질문형 퀘스트**      
 > 감정과 상황을 글로 마주하는 자기 성찰 중심의 퀘스트입니다.   
 > 이별에 대해 천천히 돌아보며 감정의 실체를 파악하고, 스스로 이해하는 과정을 돕습니다.

 > 🧗‍♂️ **행동형 퀘스트**      
 > 몸을 움직이며 감정을 정리하는 실천 중심의 퀘스트입니다.   
 >간단한 행동을 통해 머릿속을 환기시키고, 무기력에서 벗어나 스스로 일상의 루틴을 되찾을 수 있도록 유도합니다.

<br/>
<br/>

## 🍏 iOS Developers

| ![최주리](https://github.com/user-attachments/assets/a1889d8b-f465-4c5a-b661-5ff8a004b3a6) | ![허승준](https://github.com/user-attachments/assets/1377d3a0-1eab-47cb-8a3b-1bcf4aea4e00) | ![이나연](https://github.com/user-attachments/assets/288b7b27-233e-40eb-bccd-0341e81f94bc) |
|:---:|:---:|:---:|
| [**최주리 (Lead)**](https://github.com/juri123123) | [**허승준**](https://github.com/dev-domo) | [**이나연**](https://github.com/y-eonee) |
| `온보딩`, `홈` | `정보입력`, `퀘스트 조회` | `퀘스트 작성` |

<br/>
<br/>

## 🔨 Tech Stack
### UIKit
### CleanArchitecture

- 각 계층의 책임 분리를 명확하게 함으로써 앱의 확장성과 유지보수성을 높이기 위함
- 테스트가 용이한 구조
- DIContainer에서 의존성 관리

### MVVM + Combine

- 비즈니스 로직과 UI 로직을 분리해서 작성함으로써 유지보수성 높이기 위함
- Input을 enum으로 정의하여 사용자의 행동을 미리 정의
- ViewModel에서 각 Input별 행동을 매핑
- 행동에 따른 Output을 View에서 Combine을 이용하여 구독함으로써 View 갱신

### Library
| 기술/도구 | 선정 이유 |
| --- | --- |
| Alamofire | 네트워크 레이어를 보다 간편하게 사용하기 위함 |
| SnapKit | 오토레이아웃을 간편하게 설정하기 위함 |
| Then | UI 코드를 간편하게 작성하기 위함 |
| Combine | 데이터 바인딩을 편리하게 하기 위함 |
| Kingfisher | 이미지 처리 및 캐싱을 편리하게 하기 위함 |
| Lottie | 애니메이션 구현을 위함 |

<br/>
<br/>

## 📑 Structure with Clean Architecure
<img width="720" src="https://github.com/user-attachments/assets/c5530b4b-23bc-48d9-9392-3c04daed5f45" />


## 📂 Foldering
``` markdown
📁 App
│   ├── 📝 AppDelegate
│   ├── 📝 DIContainer+
│   └── 📝 SceneDelegate
├── 📁 Core
│   ├── 📝 ByeBooError
│   ├── 📝 ByeBooLogger
│   └── 📝 DIContainer
├── 📁 Data
│   ├── 📁 Config
│   ├── 📁 Model
│   ├── 📁 Network
│   │   ├── 📁 EndPoint
│   │   └── 📁 Service
│   ├── 📁 Persistence
│   │   ├── 📁 Service
│   │   └── 📝 UserDefaultsKey
│   ├── 📁 Repository
│   └── 📝 DataDependencyAssembler
├── 📁 Domain
│   ├── 📁 Entity
│   ├── 📁 Interface
│   ├── 📁 UseCase
│   └── 📝 DomainDependencyAssembler
├── 📁 Presentation
│   ├── 📁 Base
│   ├── 📁 Common
│   ├── 📁 Enum
│   ├── 📁 Extension
│   ├── 📁 Feature
│   ├── 📁 Protocol
│   ├── 🖼️ LaunchScreen
│   └── 📝 PresentationDependencyAssembler
└── 📁 Resource
```

## 📌 Convention
### Code Sytle
[Swift 스타일 쉐어 가이드](https://github.com/StyleShare/swift-style-guide)를 따릅니다

### Commit
| 태그       | 설명                                                                 |
|------------|----------------------------------------------------------------------|
| `feat`     | 새로운 기능 구현 시 사용                                              |
| `style`    | 스타일 및 UI 기능 구현 시 사용                                        |
| `fix`      | 버그나 오류 해결 시 사용                                              |
| `docs`     | README, 템플릿 등 프로젝트 내 문서 수정 시 사용                        |
| `setting`  | 프로젝트 관련 설정 변경 시 사용                                       |
| `add`      | 사진 등 에셋이나 라이브러리 추가 시 사용                              |
| `refactor` | 기존 코드를 리팩토링하거나 수정할 때 사용                             |
| `chore`    | 별로 중요한 수정이 아닐 때 사용                             |
| `hotfix`   | 급하게 develop에 바로 반영해야 하는 경우 사용 |

### Commit Message Rule
1. 반드시 **소문자**로 작성합니다.
2. 한글로 작성합니다.
3. 제목이 **50자**를 넘지 않도록, 간단하게 명령조로 작성합니다.

```markdown
feat: #1 로그인 기능 구현

add: #2 이미지 에셋 추가
```





