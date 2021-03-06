# SSAC_11_MyMeMo
아이폰 메모앱입니다.

# 구현 기능
## 📌 메모리스트 화면
- [x] 최초 실해 시 팝업 창이 뜨도록 합니다.
- [x] '고정된 메모', '메모' 2개의 섹션으로 구성합니다.
- [x] 총 작성된 메모의 갯수가 네비게이션 타이틀에 보여집니다.
- [x] 메모 갯수가 1000개를 넘길 경우, 3자리마다 콤마를 찍습니다.
- [x] 최신순으로 정렬하고 메모를 고정할 수 있습니다.
- [x] '고정된 메모'는 최대 5개입니다. 최대치에서 새로운 메모를 고정하려 한 경우, alert으 띄워줍니다.
- [x] '고정된 메모가 없다면 섹션을 표시하지 않습니다.
- [x] leading swipe를 통해 고정/해제, trailing swipe를 통해 메모가 삭제됩니다.
- [x] 메모를 삭제하기 전 한번 더 삭제 여부를 확인합니다.
- [x] 메모 리스트에 보이는 졍보는 제목, 내용, 날짜 3가지 입니다.
- [x] 날짜 정보는 오늘 작성하 메모는 '오전 08:00' 와 같은 형태로, 이번주에 작성한 메모는 '일요일, 화요일' 같은 형태로, 그 외의 기간ㅇ 작성한 메모는 '2021.10.15 오후02:00'와 같으 형태로 표시합니다.

## 📌 검색 화면
- [x] 작성한 메모(제목과 내용)을 실시간으로 검색할 수 있습니다.
- [x] 사용자가 입력하는 텍스트가 변경될 때마다 검색이 이루어집니다.
- [x] 검색 결과를 스크롤하거나 검색버튼을 누르면 키보드가 내려갑니다.
- [x] 검색 결과 갯수를 섹션에 보여줍니다.
- [x] 검색한 키워드에 해당하는 단어는 텍스트 칼러를 변경해줍니다.
- [x] 메모 고정, 삭제 기능은 검색 화면에서도 할 수 있습니다.
- [x] 셀을 클릭하면 메모 수정 화면으로 전환됩니다.

## 📌 작성/수정 화면
- [x] 메모리스트 화면 우측 하단의 작성 버튼을 클릭 시 새로운 메모를 작성할 수 있습니다.
- [x] 메모 작성 화면 진입 시 키보드를 자동으로 띄워줍니다.
- [x] '메모리스트 화면 - 셀 선택' 수정 화면으로 전환됩니다.
- [x] '검색 화면 - 셀 선택' 수정 화면으로 전환됩니다.
- [x] 수정 화면에서 사용자가 텍스트뷰 클릭하면 편집 상태가 시작됩니다.
- [x] 편집 상태가 되면 키보드 올라오고, 우측 상단 공유 버튼과 완료 버튼이 나타납니다.
- [x] 완료 버튼을 누르거나, 편집 상태가 끝나거나, 백버튼 액션, 제스처를 통해 이전 화면으로 돌아갈 경우 메모가 저장됩니다.
- [x] 어떠한 텍스트 입력되지 않았을 경우, 메모를 삭제합니다. (이 경우는 삭제 여부를 묻지 않습니다.)
- [x] 작성된 텍스트에서 사용자가 리턴키를 입력하기 전까지를 제목으로, 나머지를 내용으로 저장합니다.
- [x] 우측 상단 공유 버튼을 클릭하면 메모 텍스트가 UIActivityViewController르 통해 공유됩니다.

# 추가 구현
## 📌 모든 화면
- 라이트/다크 모드를 지원합니다.
- 앱 아이콘을 직접 제작하였습니다.

## 📌 작성/수정 화면
- 공유 & 완료 버튼을 숨길 때, 사용자에게 아예 안보이게 하지 않고 tintColor와 isEnable 속성을 바꾸어, 버튼이 있지만 편집 모드시에만 버튼 사용이 가능함을 인지할 수 있도록 구현하였습니다.

# 고민!
## ☑️ 미해결
<details>
<summary> 메모리스트화면 : 메모 삭제 혹은 고정메모 갯수 초과 시 alert문을 띄우는 기능관련 </summary>
  
  + UIViewController에 extension 해서 작성하였는데, UIAlertController에 extension 하는게 더 나았을지 (더 낫다는 기준은 어디에 두느냐에 따라 다르긴하지만!) 
  + UIAlertController에 처음에 작성하였으나 UIViewController에 한 것 보다 코드가 길어져서, 간결하게 작성하는 것이 더 좋다고 판단하여 UIViewController에 작성하였습니다.
</details>

<details>
<summary> 작성/수정화면 : 편집 상태가 되면 키보드 올라오고, 우측 상단 공유 버튼과 완료 버튼이 나타납니다. </summary>
  
  + 이 부분에서 편집 상태이면 버튼이 활성화 되고 색상이 바뀌도록 하였습니다.
  + UX 관점에서 완료 버튼을 누른 후 memoListVC로 바로 넘어갈지, addVC에 남아있을지에 대해 고민중입니다.
  + (후자가 나을 것 같다고 생각중입니다ㅎㅎ)
</details>

<details>
<summary> leading/trailing Action 기능 </summary>
  
  + tableView reload 말고 insertRow, deleteRow 로 하면 좀 더 cell의 움직임이 부드럽게 할 수 있을 것 같다.
  + 편집모드에서 메모의 내용이 없는데 공유하려 할 때 alert문 혹은 공유 버튼 isEnable = false하면 좋을 것 같다.
</details>

  + 전체적
    + localization도 하면 좋을 것 같다.

  + 검색화면 : 검색하여 메모 내용을 수정하고 나서 다시 검색화면으로 돌아오면 수정한 내용이 검색화면 안에서는 반영이 안되어있음.

## ✅ 해결
<details>
<summary> leading/trailing Swipe Action : 고정/삭제 swipe하는 과정에서의 문제 </summary>
  
  + 문제: swipe가 smooth하게 되지 않고, 하나의 셀을 swipe하고 다른 셀을 swipe하려고 하면, 첫번째 셀의 action버튼이 swipe하기 전의 상태로 돌아가고 두번째 셀은 swipe되지 않았다.
  + 해결: tableView reload를 너무 많이 해줘서 생긴 문제였던 것 같다. action 함수 안에서만 reload 해주는 방식으로 수정하였다.
</details>

<details>
<summary> 메모리스트 화면과 작성/수정 화면 간의 이동 시 navigationBar title syle 문제 </summary>
  
  + 메모리스트 -> 작성/수정 화면으로 이동 후, 다시 메모리스트 화면으로 돌아오면 기본title style로 돌아왔다. -> addVC의 viewDidLoad() 에서 .preferLargeTitles = false로 주었기 때문이다.
  + 그래서 다시 메모리스트로 돌아올 때를 대비하여 memoListVC의 viewWillAppear()에 .preferLargeTitles = true 로 주었더니 메모리스트의 타이틀이 작성/수정화면으로 이동하는 동안 계속 떠있었다.
  + 양쪽 모두 .preferLargeTitles 속성에 대한 코드를 지우고, 작성/수정화면에서만 아래의 코드를 작성해주었다.
```
    self.navigationController?.navigationBar.prefersLargeTitles = false // 수정 전
    self.navigationItem.largeTitleDisplayMode = .never // 수정 후
```
</details>
  
# 실행 영상
<img src="https://user-images.githubusercontent.com/59866819/153759253-d2ccf1cd-11f8-401f-91a5-69d72285660d.gif" />
