import 'package:epossa_app/animations/fade_animation.dart';
import 'package:epossa_app/localization/app_localizations.dart';
import 'package:epossa_app/model/user_notification.dart';
import 'package:epossa_app/notification/notification.dart';
import 'package:epossa_app/services/sharedpreferences_service.dart';
import 'package:epossa_app/services/user_notification_service.dart';
import 'package:epossa_app/styling/global_color.dart';
import 'package:epossa_app/styling/global_styling.dart';
import 'package:epossa_app/styling/size_config.dart';
import 'package:epossa_app/util/constant_field.dart';
import 'package:epossa_app/util/util.dart';
import 'package:epossa_app/validator/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactForm extends StatefulWidget {
  ContactForm(BuildContext context);

  @override
  ContactFormState createState() => new ContactFormState();
}

class ContactFormState extends State<ContactForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  UserNotification _userNotification = new UserNotification();
  UserNotificationService _notificationService = new UserNotificationService();
  SharedPreferenceService _sharedPreferenceService =
      new SharedPreferenceService();

  FormValidator formValidator = new FormValidator();

  //SearchParameter searchParameter = new SearchParameter();
  FocusNode _subjectFocusNode;
  FocusNode _messageFocusNode;

  @override
  void initState() {
    super.initState();
    _subjectFocusNode = FocusNode();
    _messageFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _subjectFocusNode.dispose();
    _messageFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    return Form(
      key: _formKey,
      autovalidate: false,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 2),
              child: Column(
                children: <Widget>[
                  buildInputForm(),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 2,
                  ),
                  buildSubmitButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputForm() {
    return FadeAnimation(
        1.3,
        Container(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]),
                  ),
                ),
                child: TextFormField(
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  style: GlobalStyling.styleFormGrey,
                  textInputAction: TextInputAction.next,
                  focusNode: _subjectFocusNode,
                  onFieldSubmitted: (term) {
                    Util.fieldFocusChange(
                        context, _subjectFocusNode, _messageFocusNode);
                  },
                  decoration: InputDecoration(
                    hintText:
                        AppLocalizations.of(context).translate('give_title'),
                    hintStyle: GlobalStyling.styleHintText,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(30),
                  ],
                  onSaved: (val) => _userNotification.title = val,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]),
                  ),
                ),
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  style: GlobalStyling.styleFormGrey,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  focusNode: _messageFocusNode,
                  onFieldSubmitted: (value) {
                    _messageFocusNode.unfocus();
                    _submitForm();
                  },
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)
                        .translate('give_your_message'),
                    hintStyle: GlobalStyling.styleHintText,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(500),
                  ],
                  validator: (val) => formValidator.isEmptyText(val)
                      ? AppLocalizations.of(context)
                          .translate('give_your_message')
                      : null,
                  onSaved: (val) => _userNotification.message = val,
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildSubmitButton() {
    return FadeAnimation(
      1.5,
      Container(
        height: SizeConfig.blockSizeVertical * 8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: GlobalColor.colorButtonPrimary,
        ),
        child: RawMaterialButton(
          onPressed: () => _submitForm(),
          child: Center(
            child: Text(
              AppLocalizations.of(context).translate('send'),
              style: GlobalStyling.styleButtonPrimary,
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      MyNotification.showInfoFlushbar(
          context,
          AppLocalizations.of(context).translate('info'),
          AppLocalizations.of(context).translate('correct_form_errors'),
          Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.red.shade300,
          ),
          Colors.red.shade300,
          2);
    } else {
      form.save();
      await _saveUserNotifikation().then((_) => showSuccessNotification());
    }
  }

  Future<void> _saveUserNotifikation() async {
    String userEmail = await _sharedPreferenceService.read(USER_PHONE);
    _userNotification.created_at = DateTime.now();
    _userNotification.useremail = userEmail;

    Map<String, dynamic> userNotificationParams =
        _userNotification.toMap(_userNotification);
    await _notificationService.save(userNotificationParams);
    await _notificationService.sendNotificationAsEmail(_userNotification);
  }

  void showSuccessNotification() {
    MyNotification.showInfoFlushbar(
        context,
        AppLocalizations.of(context).translate('info'),
        AppLocalizations.of(context).translate('thanks_for_your_message'),
        Icon(
          Icons.info_outline,
          size: 28,
          color: Colors.blue.shade300,
        ),
        Colors.blue.shade300,
        10);

    clearForm();
  }

  clearForm() {
    _formKey.currentState?.reset();
    setState(() {});
  }
}
