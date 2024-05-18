import 'package:flutter/material.dart';

class LoadingError extends StatelessWidget {
  final VoidCallback retryCallback;
  final String error;
  const LoadingError(
      {super.key, required this.retryCallback, this.error = 'Error occurred'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            error,
            style: TextStyle(
                color: Theme.of(context).colorScheme.error, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16,
          ),
          TextButton(onPressed: retryCallback, child: const Text('Retry'))
        ],
      ),
    );
  }
}
