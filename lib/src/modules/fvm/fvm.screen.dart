import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/organisms/cleanup_unused_dialog.dart';
import '../common/organisms/screen.dart';
import '../releases/releases.provider.dart';
import 'components/fvm_cache_size.dart';
import 'components/fvm_empty_releases.dart';
import 'components/fvm_release_list_item.dart';

class FVMScreen extends HookWidget {
  const FVMScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cachedVersions = useProvider(releasesStateProvider).all;

    if (cachedVersions == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (cachedVersions.isEmpty) {
      return const EmptyVersions();
    }

    return SkScreen(
      title: 'Installed Versions',
      actions: [
        Text('${cachedVersions.length} versions'),
        const SizedBox(width: 20),
        const FvmCacheSize(),
        const SizedBox(width: 20),
        Tooltip(
          message: 'Clean up unused versions.',
          child: OutlinedButton(
            onPressed: () async {
              await cleanupUnusedDialog(context);
            },
            child: const Text('Clean up'),
          ),
        )
      ],
      child: CupertinoScrollbar(
        child: ListView.separated(
          itemCount: cachedVersions.length,
          separatorBuilder: (_, __) => const Divider(height: 0),
          itemBuilder: (context, index) {
            return FvmReleaseListItem(cachedVersions[index]);
          },
        ),
      ),
    );
  }
}
