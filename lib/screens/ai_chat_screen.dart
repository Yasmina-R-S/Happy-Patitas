import 'package:flutter/material.dart';
import '../services/ai_service.dart';

class AIChatScreen extends StatefulWidget {
  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();

  String response = '';
  bool loading = false;

  Future<void> send() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      loading = true;
    });

    try {
      final result = await AIService.sendMessage(_controller.text);

      setState(() {
        response = result;
      });
    } catch (e) {
      setState(() {
        response = e.toString();
      });
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IA Veterinaria'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Pregunta algo...',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: send,
              child: const Text('Enviar'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(response),
              ),
            ),
          ],
        ),
      ),
    );
  }
}