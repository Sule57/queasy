/// ****************************************************************************
/// Created by Sophia Soares
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../src.dart';
import '../../private_category_selection_view.dart';
import '../edit_quiz_provider.dart';
import '../edit_quiz_view.dart';
import 'edit_quiz_text_field.dart';

/// The widget [AddOrEditQuestionPopUp] shows an [AlertDialog] with a form to add or edit a new question.
///
/// It shows a [TextFormField] for the question, four [TextFormField]s for the
/// options, and four [Radio]s for the correct answer.
///
/// The [validator]s check if the fields are empty or null.
///
/// The [question] variable is the question that is going to be edited. If it is null,
/// then the question is going to be added.
///
/// The [action] variable is the function that is going to be called when the user
/// confirms the addition or edition of the question.
///
/// The variable [categoryName] is the name of the category that the user is currently in.
///
/// The [_formKey] is used to validate the form.
///
/// The [_selectedRadioAnswer] is the index of the correct answer.
///
/// The [_category] is the category of the question.
///
/// The [MAX_LENGTH] is the maximum number of characters that can be entered in the
/// [TextFormField]s.
class AddOrEditQuestionPopUp extends StatefulWidget {
  Function() action;
  Question? question;
  String categoryName;

  AddOrEditQuestionPopUp({
    Key? key,
    this.question,
    required this.action,
    required this.categoryName,
  }) : super(key: key);

  @override
  State<AddOrEditQuestionPopUp> createState() => _AddOrEditQuestionPopUpState();
}

class _AddOrEditQuestionPopUpState extends State<AddOrEditQuestionPopUp> {
  // This [GlobalKey] is used to validate the form.
  final _formKey = GlobalKey<FormState>();

  get question => widget.question;
  get categoryName => widget.categoryName;

  @override
  Widget build(BuildContext context) {
    EditQuizProvider controller = Provider.of<EditQuizProvider>(context, listen: true);
    // If the question is not null, the user wants to edit a question, and the popup should
    // show the "old" correct answer as selected when the popup opens
    if (question != null) {
      controller.selectedRadioAnswer = controller.getCorrectRadioAnswer(question);
    }

    return AlertDialog(
      scrollable: true,
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      // StatefulBuilder otherwise, the radio button would not change when the user selects a different one
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            child: Form(
              key: _formKey,
              //key: _formKeyAddQuestion, _formKeyEditQuestion
              child: Column(
                // This makes the dialog have the smallest needed height.
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      EditQuizTextField(
                        controller: controller.questionController,
                        hintText: 'Question',
                        validatorText: 'Please enter a question',
                        controllerText: question == null ? '' : question.getText(),
                        question: question,
                      ),
                      Text('Correct', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      EditQuizTextField(
                        controller: controller.answer1Controller,
                        hintText: 'Answer 1',
                        validatorText: 'Please enter an answer',
                        controllerText: question == null ? '' : question.answers[0].text,
                        question: question,
                      ),
                      Radio<AnswersRadioButton>(
                          fillColor: MaterialStateProperty.all(Colors.white),
                          value: AnswersRadioButton.ans1,
                          groupValue: controller.selectedRadioAnswer,
                          onChanged: (AnswersRadioButton? value) {
                            setState(() {
                              controller.selectedRadioAnswer = value!;
                            });
                          }),
                    ],
                  ),
                  Row(
                    children: [
                      EditQuizTextField(
                        controller: controller.answer2Controller,
                        hintText: 'Answer 2',
                        validatorText: 'Please enter an answer',
                        controllerText: question == null ? '' : question.answers[1].text,
                        question: question,
                      ),
                      Radio<AnswersRadioButton>(
                          fillColor: MaterialStateProperty.all(Colors.white),
                          value: AnswersRadioButton.ans2,
                          groupValue: controller.selectedRadioAnswer,
                          onChanged: (AnswersRadioButton? value) {
                            setState(() {
                              controller.selectedRadioAnswer = value!;
                            });
                          }),
                    ],
                  ),
                  Row(
                    children: [
                      EditQuizTextField(
                        controller: controller.answer3Controller,
                        hintText: 'Answer 3',
                        validatorText: 'Please enter an answer',
                        controllerText: question == null ? '' : question.answers[2].text,
                        question: question,
                      ),
                      Radio<AnswersRadioButton>(
                          fillColor: MaterialStateProperty.all(Colors.white),
                          value: AnswersRadioButton.ans3,
                          groupValue: controller.selectedRadioAnswer,
                          onChanged: (AnswersRadioButton? value) {
                            setState(() {
                              controller.selectedRadioAnswer = value!;
                            });
                          }),
                    ],
                  ),
                  Row(
                    children: [
                      EditQuizTextField(
                        controller: controller.answer4Controller,
                        hintText: 'Answer 4',
                        validatorText: 'Please enter an answer',
                        controllerText: question == null ? '' : question.answers[3].text,
                        question: question,
                      ),
                      Radio<AnswersRadioButton>(
                        fillColor: MaterialStateProperty.all(Colors.white),
                        value: AnswersRadioButton.ans4,
                        groupValue: controller.selectedRadioAnswer,
                        onChanged: (AnswersRadioButton? value) {
                          setState(() {
                            controller.selectedRadioAnswer = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),

      // Cancel and confirm buttons.
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                // Clear all text fields
                controller.clearTextFieldsAndButton();
                Navigator.pop(context);
              },
              child: Text('Cancel'),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
            TextButton(
              child: Text('Confirm'),
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  backgroundColor: Theme.of(context).colorScheme.tertiary),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Call the function to add/edit the question to the/in database.
                  widget.action();
                  controller.clearTextFieldsAndButton();
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ],
    );
  }

}

/// The widget [DeleteQuestionPopUp] shows an [AlertDialog] to confirm the deletion of a question.
///
/// The variable [question] is the question that is going to be deleted.
class DeleteQuestionPopUp extends StatelessWidget {
  DeleteQuestionPopUp({Key? key, required this.question}) : super(key: key);
  Question question;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          const Text('Delete question', style: TextStyle(color: Colors.white)),
      content: const Text('Are you sure you want to delete this question?',
          style: TextStyle(color: Colors.white)),
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
            TextButton(
              onPressed: () async {
                Category cat = await CategoryRepo().getCategory(question.category);
                await cat.deleteQuestion(question);
                print('Question deleted');
                Navigator.pop(context);
              },
              child: Text('Confirm'),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                backgroundColor: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}


/// The widget [DeleteCategoryPopUp] shows an [AlertDialog] to confirm the deletion of a category.
///
/// The variable [category] is the category that is going to be deleted.
class DeleteCategoryPopUp extends StatelessWidget {
  DeleteCategoryPopUp({Key? key, required this.category}) : super(key: key);
  String category;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
      const Text('Delete category', style: TextStyle(color: Colors.white)),
      content: const Text('Are you sure you want to delete this category?',
          style: TextStyle(color: Colors.white)),
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
            TextButton(
              onPressed: () async {
                await CategoryRepo().deleteCategory(category);
                print('Category deleted');
                // Clear the popup
                Navigator.pop(context);
                // Go back to the previous page to show the updated list of categories
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrivateCategorySelectionView(),
                  ),
                );
              },
              child: Text('Confirm'),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                backgroundColor: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
