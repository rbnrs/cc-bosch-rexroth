import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Polls Overview", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).pushNamed('/createPoll'); 
        },
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: Center(
          child: ListView.builder(itemCount: 0, itemBuilder: (context, index) {
            return Container();
          }),
        )
      ),
    );
  }
}
