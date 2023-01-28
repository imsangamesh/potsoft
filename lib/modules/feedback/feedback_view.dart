import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:potsoft/core/constants/my_constants.dart';
import 'package:potsoft/core/utilities/utils.dart';

import '../../core/themes/my_textstyles.dart';
import '../../core/utilities/textfield_wrapper.dart';
import '../../core/widgets/my_buttons.dart';

class FeedbackView extends StatelessWidget {
  FeedbackView({super.key});

  final feedbackCntrl = TextEditingController();

  submitFeedback(BuildContext context) {
    if (feedbackCntrl.text.length < 10) {
      Utils.showAlert('Oops',
          'please make sure you\'ve added the proper description before submitting the feedback');
      return;
    }

    FocusScope.of(context).unfocus();
    try {
      fire.collection('feedbacks').doc().set({
        'feedback': feedbackCntrl.text,
        'createdOn': Timestamp.now(),
      });
      Utils.showSnackBar('feedback submitted, Thankyou', status: true);
    } catch (e) {
      Utils.normalDialog();
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback Section')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFieldWrapper(
              TextField(
                controller: feedbackCntrl,
                maxLines: 5,
                decoration: const InputDecoration.collapsed(
                  hintText: 'enter feedback',
                  hintStyle: MyTStyles.kTS15Medium,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: MyOutlinedBtn(
                'Submit Feedback',
                () => submitFeedback(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
