
// 그냥 대충 만들어 본 메인 화면. 이런 느낌이면 괜찮으려나?



import 'package:flutter/material.dart';
import 'package:exam1/ui/pages/Myprofile_page.dart';
import 'package:exam1/ui/pages/login_page.dart';

class HomePage extends StatefulWidget {
  final String token;

  const HomePage({Key? key, required this.token}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  // 샘플 게시글 데이터
  final List<Map<String, dynamic>> posts = [
    {
      "title": "게시글 제목 1",
      "content": "게시글 내용 1입니다.",
      "author": "작성자1",
      "likes": 120,
      "createdAt": DateTime.now().subtract(const Duration(hours: 1)),
    },
    {
      "title": "게시글 제목 2",
      "content": "게시글 내용 2입니다.",
      "author": "익명",
      "likes": 95,
      "createdAt": DateTime.now().subtract(const Duration(hours: 3)),
    },
    {
      "title": "게시글 제목 3",
      "content": "게시글 내용 3입니다.",
      "author": "작성자2",
      "likes": 75,
      "createdAt": DateTime.now().subtract(const Duration(days: 1)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    // 좋아요 순 + 시간 순으로 게시글 정렬
    posts.sort((a, b) {
      if (b['likes'] != a['likes']) {
        return b['likes'].compareTo(a['likes']);
      } else {
        return b['createdAt'].compareTo(a['createdAt']);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('메인 페이지'),
        actions: [
          // 로그아웃 기능
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
                (route) => false, // 이전 라우트를 모두 제거
              );
            },
            child: const Text(
              '로그아웃',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: selectedIndex == 0 ? _buildPostList() : const Center(child: Text("다른 페이지 준비 중")),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
            if (index == 4) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Profile(token: widget.token),
                ),
              );
            }
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: '내주변'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: '커뮤니티'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'MY'),
        ],
      ),
    );
  }

  // 게시글 리스트 생성
  Widget _buildPostList() {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetailPage(post: post),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("작성자: ${post['author']}"),
                      Text(
                        "${post['createdAt'].difference(DateTime.now()).inMinutes.abs()}분 전",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.thumb_up, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text("${post['likes']}"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// 게시글 상세 페이지
class PostDetailPage extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostDetailPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post['title']),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post['content'],
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.thumb_up, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text("${post['likes']} 좋아요"),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "작성자: ${post['author']}",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
