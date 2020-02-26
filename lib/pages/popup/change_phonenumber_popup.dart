import 'package:epossa_app/animations/fade_animation.dart';
import 'package:epossa_app/localization/app_localizations.dart';
import 'package:epossa_app/util/size_config.dart';
import 'package:flutter/material.dart';

class ChangePhonenumberPopup extends StatefulWidget {
  @override
  _ChangePhonenumberPopupState createState() => _ChangePhonenumberPopupState();
}

class _ChangePhonenumberPopupState extends State<ChangePhonenumberPopup> {

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  TextEditingController _phoneController = new TextEditingController();

  FocusNode _phoneFocusNode;

  @override
  void initState() {
    super.initState();
    _phoneFocusNode = new FocusNode();
  }

  @override
  void dispose() {
    //Clean up the controller when the widget is disposed
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildInputForm(),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 8,
          ),
          _buildSaveButtons(),
          SizedBox(height: SizeConfig.blockSizeVertical * 5,),
          _buildFooterMessage(),
        ],
      ),
    );
  }

  Widget _buildInputForm() {
    return FadeAnimation(
      1.5,
      Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 5,),
        child: Form(
          key: _formKey,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(143, 148, 251, .3),
                    blurRadius: 20.0,
                    offset: Offset(0, 10),
                  )
                ],
                color: Colors.white),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.grey[300]),),),
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    focusNode: _phoneFocusNode,
                    onFieldSubmitted: (term) {
                      //Save form
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.phone_iphone),
                        hintStyle:
                            TextStyle(color: Colors.grey.withOpacity(.8)),
                        hintText: AppLocalizations.of(context).translate('phonenumber')),
                    validator: (value) {
                      if (value.isEmpty) {
                        return AppLocalizations.of(context).translate('new_phonenumber_please');
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 5),
      child: FadeAnimation(
        2,
        Center(
          child: Container(
            height:  SizeConfig.blockSizeVertical * 8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromRGBO(51, 51, 153, 1),),
            child: RawMaterialButton(
              onPressed: () => _save(),
              child: Center(
                child: Text(
                  AppLocalizations.of(context).translate('save'),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterMessage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 5, vertical:  SizeConfig.blockSizeVertical * 4),
      child: FadeAnimation(
        2.3,
        Center(
          child: Text(AppLocalizations.of(context).translate('new_phonenumber'),),
        ),
      ),
    );
  }

  Future<void> _save() async {
  }

}
