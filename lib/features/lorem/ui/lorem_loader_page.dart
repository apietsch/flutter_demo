import 'dart:async';

import 'package:flutter_demo/features/auth/state/auth_controller.dart';
import 'package:flutter_demo/features/auth/ui/login_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/features/lorem/data/lorem_repository.dart';
import 'package:flutter_demo/features/screening/ui/screening_workspace_page.dart';

class LoremLoaderPage extends StatefulWidget {
  const LoremLoaderPage({
    super.key,
    required this.loader,
    required this.authController,
    this.initialUrl = 'https://brettterpstra.com/md-lipsum/api/1',
  });

  final LoremTextLoader loader;
  final AuthController authController;
  final String initialUrl;

  @override
  State<LoremLoaderPage> createState() => _LoremLoaderPageState();
}

class _LoremLoaderPageState extends State<LoremLoaderPage> {
  late final TextEditingController _urlController;
  bool _isLoading = false;
  String? _loadedText;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.initialUrl);
    unawaited(widget.authController.initialize());
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _loadText() async {
    final hasFreshSession = await widget.authController.ensureFreshSession();
    if (!hasFreshSession) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final text = await widget.loader.fetchText(_urlController.text.trim());
      if (!mounted) {
        return;
      }
      setState(() {
        _loadedText = text;
      });
    } on LoremLoadException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = error.message;
        _loadedText = null;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = 'Unexpected error. Please try again.';
        _loadedText = null;
      });
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lorem Loader'),
        actions: [
          IconButton(
            tooltip: 'Open paper screening workspace',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ScreeningWorkspacePage(),
                ),
              );
            },
            icon: const Icon(Icons.fact_check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LoginPanel(controller: widget.authController),
            const SizedBox(height: 12),
            AnimatedBuilder(
              animation: widget.authController,
              builder: (context, _) {
                final isAuthed = widget.authController.isAuthenticated;
                return TextField(
                  controller: _urlController,
                  keyboardType: TextInputType.url,
                  enabled: isAuthed,
                  decoration: const InputDecoration(
                    labelText: 'Text URL',
                    hintText: 'https://example.com/lorem.txt',
                    border: OutlineInputBorder(),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            AnimatedBuilder(
              animation: widget.authController,
              builder: (context, _) {
                if (widget.authController.isAuthenticated) {
                  return const SizedBox.shrink();
                }
                return const Text(
                  'Please sign in first to load content.',
                  style: TextStyle(color: Colors.orange),
                );
              },
            ),
            const SizedBox(height: 4),
            AnimatedBuilder(
              animation: widget.authController,
              builder: (context, _) {
                final canLoad =
                    widget.authController.isAuthenticated && !_isLoading;
                return FilledButton.icon(
                  onPressed: canLoad ? _loadText : null,
                  icon: const Icon(Icons.cloud_download),
                  label: const Text('Load'),
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: _buildContent(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.redAccent),
        ),
      );
    }

    if (_loadedText == null) {
      return const Center(
        child: Text('Press "Load" to fetch lorem ipsum text.'),
      );
    }

    return SingleChildScrollView(child: SelectableText(_loadedText!));
  }
}
