# SSAC_11_MyMeMo
아이폰 메모앱입니다.
* 주어진 시간에 가능한 만큼 구현하였으나 완성도가 낮습니다. 기회가 되면 나중에 평가와 관계없이 피드백을 받을 수 있으면 좋겠습니다 🥲🙏🏻

# 구현 기능
## 메모리스트 화면
- [x] 최초 실해 시 팝업 창이 뜨도록 합니다.
- [x] '고정된 메모', '메모' 2개의 섹션으로 구성합니다.
- [x] 총 작성된 메모의 갯수가 네비게이션 타이틀에 보여집니다.
- [ ] 메모 갯수가 1000개를 넘길 경우, 3자리마다 콤마를 찍습니다.
- [ ] 최신순으로 정렬하고 메모를 고정할 수 있습니다.
- [ ] '고정된 메모'는 최대 5개입니다. 최대치에서 새로우 메모를 고정하려 한 경우, alert으 띄워줍니다.
- [ ] '고정된 메모가 없다면 섹션을 표시하지 않습니다.
- [x] leading swipe를 통해 고정/해제, trailing swipe를 통해 메모가 삭제됩니다.
- [ ] 메모를 삭제하기 전 한번 더 삭제 여부를 확인합니다.
- [ ] 메모 리스트에 보이는 졍보는 제목, 내용, 날짜 3가지 입니다.
- [ ] 날짜 정보는 오늘 작성하 메모는 '오전 08:00' 와 같은 형태로, 이번주에 작성한 메모는 '일요일, 화요일' 같은 형태로, 그 외의 기간ㅇ 작성한 메모는 '2021.10.15 오후02:00'와 같으 형태로 표시합니다.

## 검색 화면
- [ ] 작성하 메모(제목과 내용)을 실시간으로 검색할 수 있습니다.
- [ ] 사용자가 입력하는 텍스트가 변경될 때마다 검색이 이루어집니다.
- [ ] 검색 결과를 스크롤하거나 검색버튼을 누르면 키보드가 내려갑니다.
- [ ] 검색 결과 갯수를 섹션에 보여줍니다.
- [ ] 검색한 키워드에 해당하는 단어는 텍스트 칼러를 변경해줍니다.
- [ ] 메모 고정, 삭제 기능은 검색 화면에서도 할 수 있습니다.
- [ ] 셀을 클릭하면 메모 수정 화면으로 전환됩니다.

## 작성/수정 화면
- [x] 메모리스트 화면 우측 하단의 작성 버튼을 클릭 시 새로운 메모를 작성할 수 있습니다.
- [x] 메모 작성 화면 진입 시 키보드를 자동으로 띄워줍니다.
- [x] '메모리스트 화면 - 셀 선택' 수정 화면으로 전환됩니다.
- [ ] '검색 화면 - 셀 선택' 수정 화면으로 전환됩니다.
- [ ] 수정 화면에서 사용자가 텍스트뷰 클릭하면 편집 상태가 시작됩니다.
- [ ] 편집 상태가 되면 키보드 올라오고, 우측 상단 공유 버튼과 완료 버튼이 나타납니다.
- [ ] 완료 버튼을 누르거나, 편집 상태가 끝나거나, 백버튼 액션, 제스처를 통해 이전 화면으로 돌아갈 경우 메모가 저장됩니다.
- [ ] 어떠한 텍스트 입력되지 않았을 경우, 메모를 삭제합니다. (이 경우는 삭제 여부를 묻지 않습니다.)
- [ ] 작성된 텍스트에서 사용자가 리턴키를 입력하기 전까지를 제목으로, 나머지를 내용으로 저장합니다.
- [ ] 우측 상단 공유 버튼을 클릭하면 메모 텍스트가 UIActivityViewController르 통해 공유됩니다.

# 최초 실행 시 팝업창이 뜨는 모습
<img src="https://user-images.githubusercontent.com/59866819/141436620-0ebf6731-2376-4528-9d1d-beed34ce0eef.mp4" />

# 실행 영상
* 미완성

