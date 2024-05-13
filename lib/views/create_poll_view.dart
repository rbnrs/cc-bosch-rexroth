import 'package:flutter/material.dart';

class CreatePollView extends StatefulWidget {
  const CreatePollView({super.key});

  @override
  State<CreatePollView> createState() => _CreatePollViewState();
}

class _CreatePollViewState extends State<CreatePollView> {

  final double _formElementMargin = 15;
  final double _formControlMargin = 30;

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
                child: Container(
                  margin: const EdgeInsets.all(15),
                  constraints: const BoxConstraints(minWidth: 500),
                  width: screenWidth > 500 ? screenWidth * .3 : 500,
                  child: createPollForm(),
                )
            ),
          )
        ],
      ),
    );
  }

  Widget createPollForm(){

    double buttonHeight = 50;

    return Column(
      children: [
        createPollNameInput(),
        SizedBox(height: _formControlMargin,),
        createPollDescription(),
        SizedBox(height: _formControlMargin,),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pushNamed('/addQuestion');
                  },
                  child: const Text("Add Question"),
                ),
              )
            ),
          ],
        )


      ],
    );
  }

  Widget createPollNameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Name", style: Theme.of(context).textTheme.labelLarge,),
        SizedBox(
          height: _formElementMargin,
        ),
        TextFormField(
          decoration: const InputDecoration(
              hintText: "Enter poll name..."
          ),
          onChanged: (val) {
          },
        ),
      ],
    );
  }

  Widget createPollDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Description", style: Theme.of(context).textTheme.labelLarge,),
        SizedBox(
          height: _formElementMargin,
        ),
        TextFormField(
          decoration: const InputDecoration(
              hintText: "Enter poll description..."
          ),
          maxLines: 5,
          maxLength: 250,
          onChanged: (val) {
          },
        ),
      ],
    );
  }
}
