# ChatBuddy - Ứng Dụng Luyện Hội Thoại Tiếng Nhật Thông Minh

## 📋 Tổng Quan Dự Án

**ChatBuddy** là một ứng dụng di động (Flutter) giúp người học tiếng Nhật cải thiện kỹ năng giao tiếp thông qua:

1. **Cuộc trò chuyện tự nhiên** - Chat với chatbot AI theo ngữ cảnh
2. **Phân tích lỗi ngữ pháp** - AI phát hiện và sửa lỗi trong real-time
3. **Gợi ý cá nhân hóa** - Recommendations dựa trên lịch sử học của người dùng
4. **Theo dõi tiến bộ** - Thống kê chi tiết giúp người dùng nhận ra điểm yếu

---

## 🎯 Mục Đích Của Dự Án

Giải quyết vấn đề sau:

- ❌ **Vấn đề cũ**: Chỉ cung cấp môi trường chat, không phát hiện và sửa lỗi
- ✅ **Giải pháp**: Xây dựng hệ thống phân tích hội thoại + gợi ý học tập cá nhân hóa
- 🎓 **Kết quả**: Giúp người dùng cải thiện tiếng Nhật **có hệ thống, bền vững**

---

## 📱 Các Màn Hình Chính

### 1. **Chat Screen** (`lib/presentation/chat/`)

- Giao diện chat với chatbot tiếng Nhật
- Tính năng: gửi tin nhắn, nhận phản hồi
- **Chưa làm**: Tích hợp phát hiện lỗi real-time

### 2. **Statistic Screen** (`lib/presentation/statistic/statistic_screen.dart`)

- **Chức năng**: Hiển thị danh sách các câu có lỗi
- **Cấu trúc**:
  - Compact view (1 dòng) - tin nhắn + gợi ý preview + thời gian
  - Click để mở expanded view - chi tiết sửa + tất cả gợi ý
- **Dữ liệu hiện tại**: Fake data (4 câu sai)
- **Model**: `ConversationStatistic` với fields:
  - `userMessage` - Tin nhắn gốc
  - `correction` - Câu sửa (nếu có lỗi)
  - `hasError` - Cờ lỗi
  - `improvements` - Danh sách gợi ý
  - `timestamp` - Thời gian

### 3. **Auth Screen** (`lib/presentation/auth/`)

- Đăng nhập / Đăng ký

### 4. **Profile Screen** (`lib/presentation/profile/`)

- Thông tin người dùng

### 5. **Learning Screen** (`lib/presentation/learning/`)

- Bài học chi tiết (chưa làm)

### 6. **Settings Screen** (`lib/presentation/settings/`)

- Cài đặt ứng dụng (chưa làm)

---

## 🏗️ Cấu Trúc Thư Mục

```
lib/
├── main.dart                 # Entry point
├── core/                     # Hằng số, routes, theme, widgets chung
│   ├── constants/
│   ├── routes/
│   ├── theme/
│   └── widgets/
├── data/                     # API, database, models
│   ├── models/
│   ├── repositories/
│   └── services/
├── presentation/             # UI screens
│   ├── main_screen.dart     # Màn hình chính (bottom nav)
│   ├── auth/
│   ├── chat/
│   ├── learning/
│   ├── profile/
│   ├── settings/
│   └── statistic/           # ← Màn hình thống kê (LÀM XONG)
└── state/                    # State management (Riverpod)
    ├── auth_notifier.dart
    ├── auth_state.dart
    └── auth_state.freezed.dart
```

---

## 🔄 Data Flow

```
ChatBuddy (Chat)
    ↓
AI phát hiện lỗi + tạo gợi ý
    ↓
Lưu vào ConversationStatistic
    ↓
StatisticScreen hiển thị
    ↓
Người dùng học từ lỗi của mình
```

---

## 🛠️ Công Nghệ Sử Dụng

- **Framework**: Flutter (Dart)
- **State Management**: Riverpod
- **Freezed**: Code generation cho immutable models
- **API**: (Chưa xác định - cần backend)

---

## 📊 Fake Data Hiện Tại (Statistic Screen)

4 câu lỗi tiếng Nhật:

| #   | Lỗi                        | Sửa                        | Loại            |
| --- | -------------------------- | -------------------------- | --------------- |
| 1   | `きのうは映画を見ています` | `きのうは映画を見ました`   | Lỗi thì động từ |
| 2   | `あなたは誰ですか`         | `あなたはだれですか`       | Lỗi kanji       |
| 3   | `わたしが学校を行きました` | `わたしは学校に行きました` | Lỗi助詞         |
| 4   | `これは私の本です`         | `これはわたしの本です`     | Lỗi kanji       |

---

## 🎓 Các Bước Phát Triển Tiếp Theo

### Phase 1 (Hiện tại)

- ✅ Thiết kế UI các màn hình
- ✅ Fake data cho Statistic Screen
- ⏳ Integrate real backend API

### Phase 2

- 🔄 Tính năng phân tích lỗi real-time trong chat
- 🔄 Tích hợp AI để phát hiện lỗi ngữ pháp
- 🔄 Tính năng gợi ý cá nhân hóa

### Phase 3

- 🔄 Dashboard thống kê chi tiết (biểu đồ, xu hướng)
- 🔄 Hệ thống streak / achievements
- 🔄 Bài học tương tác (minigames, flashcards)

---

## 💡 Ghi Chú Quan Trọng

1. **ConversationStatistic Model**:
   - `hasError` = true → Chỉ show những câu có lỗi
   - `correction` = câu sửa (so sánh trực quan)
   - `improvements` = list gợi ý (emoji + text)

2. **UI/UX**:
   - **Compact**: Gọn gàng, dễ scan
   - **Expandable**: Click để xem chi tiết
   - **Color-coded**: 🟢 (đúng) / 🟠 (sai)

3. **Thời gian**:
   - Hiển thị rút gọn: 2m, 3h, 5d (thay vì "2 phút trước")

---

## 📞 Liên Hệ / Ghi Chú

- **Ngôn ngữ**: Tiếng Nhật (学習用)
- **Đối tượng**: Người học tiếng Nhật sơ cấp - trung cấp
- **Status**: Đang phát triển (UI gần xong, backend cần làm)

---

**Cập nhật lần cuối**: 31/05/2026
