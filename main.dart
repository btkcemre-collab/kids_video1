import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

void main() {
  runApp(const KidsVideoApp());
}

class KidsVideoApp extends StatelessWidget {
  const KidsVideoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neşeli Minik Videolar',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const KidsVideoPage(),
    );
  }
}

class KidsVideoPage extends StatefulWidget {
  const KidsVideoPage({super.key});

  @override
  State<KidsVideoPage> createState() => _KidsVideoPageState();
}

class _KidsVideoPageState extends State<KidsVideoPage> {
  final _controller = TextEditingController(
      text: "Mutlu dinozor balonlarla dans ediyor");
  String? _videoUrl;
  bool _loading = false;

  Future<void> _generate() async {
    setState(() => _loading = true);

    await Future.delayed(const Duration(seconds: 2));

    // 🔹 Buraya ileride Firebase Cloud Function veya gerçek API bağlanacak
    const dummyUrl =
        "https://sample-videos.com/video123/mp4/480/asdasdas.mp4";

    setState(() {
      _videoUrl = dummyUrl;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Neşeli Minik Videolar")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLength: 120,
              decoration: const InputDecoration(
                labelText: "Ne görmek istiyorsun?",
                helperText: "Örn: Mutlu dinozor balonlarla dans ediyor",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _loading ? null : _generate,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text("Oluştur"),
            ),
            const SizedBox(height: 16),
            if (_videoUrl != null)
              Expanded(child: _Player(url: _videoUrl!)),
          ],
        ),
      ),
    );
  }
}

class _Player extends StatefulWidget {
  final String url;
  const _Player({required this.url});

  @override
  State<_Player> createState() => _PlayerState();
}

class _PlayerState extends State<_Player> {
  late final VideoPlayerController _vc;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _vc = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _vc,
            autoPlay: true,
            looping: true,
          );
        });
      });
  }

  @override
  void dispose() {
    _vc.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_vc.value.isInitialized || _chewieController == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Chewie(controller: _chewieController!);
  }
}
