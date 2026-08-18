# Fastlane, GitHub Actions을 통한 CI/CD

### 0. 개요

`develop`/`release` 브랜치에 PR이 머지될 때 Fastlane을 통해 자동으로 TestFlight / App Store에 배포되는 CI/CD 파이프라인을 구축했습니다. .

- `develop` → PR Merge 시 → **TestFlight** 자동 업로드
- `release` → PR Merge 시 → **App Store** 자동 심사 제출
- CI/CD 결과는 Discord로 알림 전송

---

### 1. 기본 구조 설계

```
ByeBoo-iOS/
├── fastlane/
│   ├── Fastfile        # 배포 lane 정의
│   ├── Appfile          # 앱 식별 정보
│   ├── Matchfile        # 코드사이닝 인증서 관리 설정
│   └── metadata/
│       └── ko/
│           └── release_notes.txt   # Release Note 관리
├── Gemfile
└── ByeBoo-iOS.xcodeproj

.github/workflows/
└── fastlane-ci.yml      # GitHub Actions 워크플로우
```

### 2. App Store Connect API

#### 도입

처음엔 Apple ID + 비밀번호 기반 인증(`APPLE_ID`, `APPLE_PASSWORD`, `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD`)으로 시작했으나, 2단계 인증(2FA)이 걸린 계정은 CI 환경에서 위 방식을 통한 로그인이 막힌다는 걸 확인했습니다. 이후 비밀번호 기반 인증에서 **App Store Connect API Key** 방식으로 전환했습니다.

#### 개념

- App Store Connect의 작업을 자동화할 수 있도록 Apple이 공식 제공하는 **REST API**
- 계정 로그인(Apple ID + 비밀번호) 없이, 비대칭키 기반 서명(JWT)으로 인증하는 방식
- CI/CD처럼 사람이 개입할 수 없는 무인 환경을 위해 설계된 인증 수단

#### 동작 원리

1. App Store Connect에서 API Key를 발급받으면 개인키(Private Key, `.p8` 파일)를 다운로드하게 됩니다. 이 파일은 최초 1회만 다운로드 가능하며 Apple 서버에는 공개키만 보관됩니다. 
2. fastlane이 이 개인키로 JWT 토큰을 코드가 직접 생성합니다. 이 토큰 안에는 Key ID, Issuer ID, 만료시간 등이 서명되어 담김
3. API 요청을 보낼 때 이 JWT 토큰을  `Authorization: Bearer {token}` 헤더에 실어서 전송합니다. 
4. Apple 서버는 별도의 로그인 세션 없이, **서명이 유효한지 검증**만 하고 요청을 처리합니다.

#### 구성 요소 3가지

| 값 | 설명 |
| --- | --- |
| **Key ID** | API Key 발급 시 부여되는 고유 식별자 |
| **Issuer ID** | 팀(조직) 전체에 공통으로 부여되는 발급자 ID |
| **Private Key (.p8)** | 실제 서명에 쓰이는 개인키 파일. 한 번만 다운로드 가능하므로 안전하게 보관 필요 |

### 3. GitHub Secrets 설계

#### GitHub Secrets 목록

| Secret | 용도 |
| --- | --- |
| `APP_STORE_CONNECT_API_KEY_KEY_ID` | App Store Connect API Key ID |
| `APP_STORE_CONNECT_API_KEY_ISSUER_ID` | API Key Issuer ID |
| `APP_STORE_CONNECT_API_KEY_CONTENT` | `.p8` 키 파일을 base64 인코딩한 값 |
| `APP_IDENTIFIER` | 앱 번들 ID |
| `TEAM_ID` | Apple Developer Team ID |
| `PRIVATE_REPOSITORY` | Match 인증서를 저장하는 private git repo URL |
| `MATCH_GIT_BASIC_AUTHORIZATION` | Match repo 접근용 `username:PAT`를 base64 인코딩한 값 |
| `MATCH_PASSWORD` | Match 인증서 암복호화 비밀번호 |
| `DISCORD_URL` | 배포 결과 알림용 Discord 웹훅 URL |

#### API Key 발급 및 인코딩 방법

```bash
# .p8 파일 내용을 인코딩하여 APP_STORE_CONNECT_API_KEY_CONTENT 값으로 등록합니다. 
base64 -i AuthKey_XXXXXXXXXX.p8 | pbcopy
```

#### Match Git 인증 값 생성 방법

```bash
# MATCH_GIT_BASIC_AUTHORIZATION 값으로 등록
# 해당 레포지토리에 접근할 수 있는 계정이 생성한 액세스토큰만 가능함
echo -n "GitHub유저네임:PersonalAccessToken" | base64
```

### 4. Fastfile 구성

- `prepare_ci_and_signing`
    - API Key 인증
    - CI 환경 세팅(`setup_ci`)
    - 인증서/프로파일 다운로드(`match`)
    - 프로젝트 팀 ID 동기화(`update_project_team`)
- `next_build_number`
    - 빌드 번호를 **한국시간 기준 `YYYYMMDDHHMM`** 형식으로 생성하여 재배포 시에도 항상 이전보다 큰 값을 보장합니다.
- `notify_discord_success` / `notify_discord_failure`
    - TestFlight 업로드 / 배포 결과를 Discord 웹훅으로 알림을 전송합니다.
    - 두 lane 모두 `begin/rescue`로 감싸서 실패 시에도 Discord 알림 후 CI를 실패 처리합니다.

#### 사용한 `upload_to_app_store` 옵션 정리

| 옵션 | 값 | 의미 |
| --- | --- | --- |
| `submit_for_review` | `true` | 업로드 후 자동으로 심사 제출 |
| `automatic_release` | `false` | 심사 통과 후 자동 배포하지 않고, 수동으로 "출시" 버튼을 눌러야 배포됨 |
| `precheck_include_in_app_purchases` | `false` | 인앱결제 없으므로 precheck 스캔에서 제외 |
| `submission_information.add_id_info_uses_idfa` | `false` | 광고 추적 SDK(IDFA) 미사용 |
| `submission_information.export_compliance_uses_encryption` | `false` | 표준 HTTPS 통신 외 별도 암호화 미사용 |
| `skip_metadata` | `false` | `release_notes.txt`(What's New)를 반영하기 위해 활성화 |
| `skip_app_version_update` | `true` | What's New 외 다른 메타데이터(설명, 키워드 등)는 건드리지 않음 |

#### Release Note 관리

배포 때마다 코드를 수정하지 않도록, `fastlane/metadata/ko/release_notes.txt` 파일을 별도로 관리합니다. 배포 전 이 파일의 내용만 갱신하고 커밋하면 자동으로 반영됩니다. 

### 5. GitHub Actionss Workflow 
- `pull_request` + `types: [closed]` + `if: merged == true`
    - **PR이 실제로 머지될 때만** 실행합니다. (단순 close일 때는 실행되지 않습니다.) 
- `github.event.pull_request.base.ref`로 어느 브랜치에 머지됐는지 판별해 lane을 분기합니다.
- `defaults.run.working-directory`로 모든 step이 `ByeBoo-iOS/` 하위(Gemfile, Fastfile이 있는 위치)에서 실행되도록 통일합니다.
