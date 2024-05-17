import 'package:flutter/material.dart';

class GeneralFragments {
  static SnackBar createInfoSnackbar(String text, BuildContext context) {
    return SnackBar(
      content: Text(text),
      backgroundColor: Theme.of(context).primaryColorLight,
    );
  }

  static SnackBar createErrorSnackbar(String text, BuildContext context) {
    return SnackBar(
      content: Text(text),
      backgroundColor: Theme.of(context).colorScheme.error,
    );
  }

  static Widget createLoadingDialog(BuildContext context) {
    return const AlertDialog(
      content: SizedBox(
        height: 150,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  static createAppBar(String title, bool navBack, BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(
          color: Theme.of(context).primaryColor,
          height: 2,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColorDark,
            ),
      ),
      automaticallyImplyLeading: navBack,
      foregroundColor: Colors.grey,
    );
  }
}
