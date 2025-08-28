import 'package:bitelogik/ui/core/ui/app_button.dart';
import 'package:bitelogik/ui/core/ui/custom_text.dart';
import 'package:bitelogik/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../routing/route_names.dart';
import '../../auth/view_model/auth_controller.dart';
import '../view_model/counter_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter Screen"),
        actions: [
          IconButton(
            onPressed: () async {
              await ref.read(authControllerProvider).logout();
             context.go(RoutePath.loginScreen);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              CustomText(text: "Counter: $counter",fontSize: 33),
              80.height,
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AppButton(
                    onPressed: () => ref.read(counterControllerProvider.notifier).increment(),
                    text: "Increment"),
                  AppButton(
                    onPressed: () => ref.read(counterControllerProvider.notifier).decrement(),
                    text: "Decrement",
                  ),
                ],
              ),
              Spacer(),
              AppButton(
                width: double.infinity,
                onPressed: () => ref.read(counterControllerProvider.notifier).reset(),
                text: "Reset",
              ),
              50.height,
            ],
          ),
        ),
      ),
    );
  }
}
