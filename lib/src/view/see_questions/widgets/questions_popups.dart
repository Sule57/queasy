/// ****************************************************************************
/// Created by Sophia Soares
/// Collaborators: Julia Agüero
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:queasy/src/view/my_quizzes/quiz_questions_view.dart';
import '../../../../src.dart';
import '../../../../utils/exceptions.dart';
import '../category_questions_provider.dart';
import '../category_questions_view.dart';
import 'questions_text_field.dart';

/// The widget [AddOrEditQuestionPopUp] shows an [AlertDialog] with a form to add or edit a new question.
///
/// It shows a [TextFormField] for the question, four [TextFormField]s for the
/// options, and four [Radio]s for the correct answer.
class AddOrEditQuestionPopUp extends StatefulWidget {
  /// The function that is going to be called when the user confirms the addition or edition of the question.
  final Function() action;

  /// The question that is going to be edited or added. If it is null, the
  /// question is going to be added, otherwise it is going to be edited.
  final Question? question;

  /// The name of the category that the user is currently in.
  final String categoryName;

  AddOrEditQuestionPopUp({
    Key? key,
    this.question,
    required this.action,
    required this.categoryName,
  }) : super(key: key);

  @override
  State<AddOrEditQuestionPopUp> createState() => _AddOrEditQuestionPopUpState();
}

/// The state of the widget [AddOrEditQuestionPopUp].
class _AddOrEditQuestionPopUpState extends State<AddOrEditQuestionPopUp> {
  /// Used to validate the form.
  final _formKey = GlobalKey<FormState>();

  get question => widget.question;

  get categoryName => widget.categoryName;

  @override
  Widget build(BuildContext context) {
    /// The provider of the class
    CategoryQuestionsProvider controller =
        Provider.of<CategoryQuestionsProvider>(context, listen: true);

    // If the question is not null, the user wants to edit a question, and the popup should
    // show the "old" correct answer as selected when the popup opens
    if (question != null) {
      controller.selectedRadioAnswer =
          controller.getCorrectRadioAnswer(question);
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
              child: Column(
                // This makes the dialog have the smallest needed height.
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      QuestionsTextField(
                        controller: controller.questionController,
                        hintText: 'Question',
                        validatorText: 'Please enter a question',
                        controllerText:
                            question == null ? '' : question.getText(),
                        question: question,
                        isQuestion: true,
                        action: widget.action,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      QuestionsTextField(
                        controller: controller.answer1Controller,
                        hintText: 'Answer 1',
                        validatorText: 'Please enter an answer',
                        controllerText:
                            question == null ? '' : question.answers[0].text,
                        question: question,
                        isQuestion: false,
                        action: widget.action,
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
                      QuestionsTextField(
                        controller: controller.answer2Controller,
                        hintText: 'Answer 2',
                        validatorText: 'Please enter an answer',
                        controllerText:
                            question == null ? '' : question.answers[1].text,
                        question: question,
                        isQuestion: false,
                        action: widget.action,
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
                      QuestionsTextField(
                        controller: controller.answer3Controller,
                        hintText: 'Answer 3',
                        validatorText: 'Please enter an answer',
                        controllerText:
                            question == null ? '' : question.answers[2].text,
                        question: question,
                        isQuestion: false,
                        action: widget.action,
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
                      QuestionsTextField(
                        controller: controller.answer4Controller,
                        hintText: 'Answer 4',
                        validatorText: 'Please enter an answer',
                        controllerText:
                            question == null ? '' : question.answers[3].text,
                        question: question,
                        isQuestion: false,
                        action: widget.action,
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
class DeleteQuestionPopUp extends StatefulWidget {
  DeleteQuestionPopUp({Key? key, required this.question}) : super(key: key);
  final Question question;

  @override
  State<DeleteQuestionPopUp> createState() => _DeleteQuestionPopUpState();
}

class _DeleteQuestionPopUpState extends State<DeleteQuestionPopUp> {
  @override
  Widget build(BuildContext context) {
    /// The provider of the class
    final CategoryQuestionsProvider controller =
        Provider.of<CategoryQuestionsProvider>(context, listen: true);

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
              onPressed: () {
                controller.deleteQuestionFromDatabase(widget.question);
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

/// This widget is used to display an [AlertDialog] to add a new category.
class NewCategoryPopUp extends StatefulWidget {
  /// Constructor of the class.
  const NewCategoryPopUp({
    Key? key,
  }) : super(key: key);

  @override
  State<NewCategoryPopUp> createState() => _NewCategoryPopUpState();
}

/// The state of the widget [NewCategoryPopUp].
class _NewCategoryPopUpState extends State<NewCategoryPopUp> {
  /// The controller of the text field of the category name.
  final TextEditingController newCategoryController = TextEditingController();

  @override
  void dispose() {
    newCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// The provider of the class
    final CategoryQuestionsProvider controller =
        Provider.of<CategoryQuestionsProvider>(context, listen: true);

    return AlertDialog(
      title: const Text(
        'Add a new category',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      content: TextField(
        controller: newCategoryController,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: 'Category name',
          hintStyle: TextStyle(color: Colors.white),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        onSubmitted: (value) async {
          // Check if the entered text is empty of filled with spaces
          if (newCategoryController.text.trim().isEmpty) {
            // Show an alert dialog to inform the user that the category
            // name cannot be empty
            Future.delayed(Duration.zero, () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AlertDialog(
                    title: Text('Category name cannot be empty'),
                  );
                },
              );
            });
          } else {
            // Add the new category to the database
            try {
              await controller
                  .addCategoryToDatabase(newCategoryController.text);
              Navigator.pop(context); // Close the alert dialog
            } on CategoryAlreadyExistsException catch (e) {
              // Show an alert dialog to inform the user that the category
              // name already exists
              Future.delayed(Duration.zero, () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      title: Text('Category already exists'),
                    );
                  },
                );
              });
            }
          }
        },
      ),
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
                // Check if the entered text is empty of filled with spaces
                if (newCategoryController.text.trim().isEmpty) {
                  // Show an alert dialog to inform the user that the category
                  // name cannot be empty
                  Future.delayed(Duration.zero, () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AlertDialog(
                          title: Text('Category name cannot be empty'),
                        );
                      },
                    );
                  });
                } else {
                  // Add the new category to the database
                  try {
                    await controller
                        .addCategoryToDatabase(newCategoryController.text);
                    Navigator.pop(context); // Close the alert dialog
                  } on CategoryAlreadyExistsException catch (e) {
                    // Show an alert dialog to inform the user that the category
                    // name already exists
                    Future.delayed(Duration.zero, () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AlertDialog(
                            title: Text('Category already exists'),
                          );
                        },
                      );
                    });
                  }
                }
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
class DeleteCategoryPopUp extends StatefulWidget {
  DeleteCategoryPopUp({Key? key, required this.category}) : super(key: key);

  /// The category that is going to be deleted.
  final String category;

  @override
  State<DeleteCategoryPopUp> createState() => _DeleteCategoryPopUpState();
}

class _DeleteCategoryPopUpState extends State<DeleteCategoryPopUp> {
  @override
  Widget build(BuildContext context) {
    /// The provider of the class
    final CategoryQuestionsProvider controller =
        Provider.of<CategoryQuestionsProvider>(context, listen: true);

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
              onPressed: () {
                controller.deleteCategoryFromDatabase();
                // Clear the popup
                Navigator.pop(context);
                // Go back to the previous page to show the updated list of categories
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

/// Popup for creating a random quiz.
///
/// It is shown when the user presses the button "Random quiz" in the
/// [PrivateCategorySelectionView].
///
/// It shows an [AlertDialog] with a [TextField] to choose the name of the
/// quiz and a text field to choose the number of questions.
class CreateRandomQuizPopup extends StatelessWidget {
  /// Constructor of the class.
  const CreateRandomQuizPopup({Key? key}) : super(key: key);

  /// Build the view.
  ///
  /// Returns an alert dialog that asks the user how many questions he wants to
  /// include in the quiz and takes only an int in the text-field.
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final CategoryQuestionsProvider controller =
        Provider.of<CategoryQuestionsProvider>(context);
    TextStyle? titleStyle = theme.textTheme.headline6!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    TextStyle? textStyle = theme.textTheme.subtitle2?.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    TextStyle inputTextStyle = theme.textTheme.subtitle2?.copyWith(
      color: theme.colorScheme.onBackground,
    );

    return AlertDialog(
      backgroundColor: theme.colorScheme.primary,
      title: Text(
        'Creating a quiz',
        style: titleStyle,
      ),
      content: Form(
        key: controller.formKeyCreateRandomQuiz,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  'Name: ',
                  style: textStyle,
                ),
                Expanded(
                  child: SizedBox(
                    height: 30,
                    child: TextFormField(
                      style: inputTextStyle,
                      controller: controller.newQuizNameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10, left: 20),
                        filled: true,
                        fillColor: Colors.white,
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Number of questions: ',
                  style: textStyle,
                ),
                Expanded(
                  child: SizedBox(
                    height: 30,
                    child: TextFormField(
                      style: inputTextStyle,
                      controller: controller.numberOfQuestionsController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10, left: 20),
                        filled: true,
                        fillColor: Colors.white,
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a number';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _confirm(context),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              child: Text('Create quiz'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.tertiary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () => _confirm(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Function called when the user confirms the creation of the quiz.
  ///
  /// It is called either in the onPressed of the ElevatedButton or when the
  /// user presses the enter key on the keyboard on the last text field.
  ///
  /// It checks if the form is valid and if it is, it creates the quiz and
  /// navigates to the quiz page.
  _confirm(BuildContext context) async {
    final CategoryQuestionsProvider controller =
        Provider.of<CategoryQuestionsProvider>(context, listen: false);
    String? quizId;

    if (controller.formKeyCreateRandomQuiz.currentState!.validate()) {
      quizId = await controller.createAndStoreRandomQuiz();

      if (quizId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred'),
          ),
        );
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => QuizQuestionsView(
                  quizId: quizId!,
                )));
        controller.numberOfQuestionsController.clear();
        controller.newQuizNameController.clear();
      }
    }
  }
}

/// Popup for creating a custom quiz from a category.
///
/// It is shown when the user presses the button "Custom quiz" in the
/// [PrivateCategorySelectionView].
///
/// It shows an [AlertDialog] with a [TextField] to choose the name of the
/// quiz. It also shows a list of questions from the category that the user can
/// select with a checkbox to be included in the quiz.
class CreateCustomQuizPopup extends StatelessWidget {
  /// Constructor of the class.
  const CreateCustomQuizPopup({Key? key}) : super(key: key);

  /// Build the view.
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final CategoryQuestionsProvider controller =
        Provider.of<CategoryQuestionsProvider>(context);
    TextStyle? titleStyle = theme.textTheme.headline5!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    TextStyle? textStyle = theme.textTheme.subtitle2?.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    TextStyle inputTextStyle = theme.textTheme.subtitle2?.copyWith(
      color: theme.colorScheme.onBackground,
    );

    return AlertDialog(
      backgroundColor: theme.colorScheme.primary,
      title: Text(
        'Creating a quiz',
        style: titleStyle,
        textAlign: TextAlign.center,
      ),
      content: Form(
        key: controller.formKeyCreateCustomQuiz,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'Name: ',
                  style: textStyle,
                ),
                Expanded(
                  child: SizedBox(
                    height: 30,
                    child: TextFormField(
                      style: inputTextStyle,
                      controller: controller.newQuizNameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10, left: 20),
                        filled: true,
                        fillColor: Colors.white,
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: height / 2.5,
              width: width,
              child: ListView.builder(
                itemCount: controller.questionList.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(
                      controller.questionList[index].text,
                      style: textStyle,
                    ),
                    value: controller.isQuestionChecked[index],
                    checkColor: theme.colorScheme.onPrimary,
                    activeColor: theme.colorScheme.tertiary,
                    controlAffinity: ListTileControlAffinity.trailing,
                    onChanged: (value) => controller.updateIsQuestionChecked(
                      index: index,
                      value: value ?? false,
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              child: Text('Create quiz'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.tertiary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () => _confirm(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Function called when the user confirms the creation of the quiz.
  ///
  /// It is called either in the onPressed of the ElevatedButton or when the
  /// user presses the enter key on the keyboard on the last text field.
  ///
  /// It checks if the form is valid and if it is, it creates the quiz and
  /// navigates to the quiz page.
  _confirm(BuildContext context) async {
    final CategoryQuestionsProvider controller =
        Provider.of<CategoryQuestionsProvider>(context, listen: false);

    if (controller.formKeyCreateCustomQuiz.currentState!.validate()) {
      List<String> questionIds = [];
      String? quizId;

      for (int i = 0; i < controller.isQuestionChecked.length; i++)
        if (controller.isQuestionChecked[i])
          questionIds.add(controller.questionList[i].id);

      quizId =
          await controller.createAndStoreCustomQuiz(questionIds: questionIds);

      if (quizId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred'),
          ),
        );
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => QuizQuestionsView(
                  quizId: quizId!,
                )));
        controller.newQuizNameController.clear();
        controller.clearIsQuestionChecked();
      }
    }
  }
}
