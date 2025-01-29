part of '../screen.dart';

class NewEmailScreen extends StatefulWidget {
  const NewEmailScreen({super.key});

  @override
  State<NewEmailScreen> createState() => _NewEmailScreenState();
}

class _NewEmailScreenState extends State<NewEmailScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const AppBackButton(),
        titleSpacing: 0,
        title: const Text("Change Email Address",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        centerTitle: false,
        forceMaterialTransparency: true,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.fromLTRB(
          UiConstant.horizontalPadding,
          30,
          UiConstant.horizontalPadding,
          10,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                _CustomTextFormField(
                  hint: 'email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  controller: _emailController,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Provider.of<ProfileViewModel>(context, listen: false)
                          .updateEmail(
                        context: context,
                        newEmail: _emailController.text.trim(),
                      );
                      // Handle the saved phone number
                    }
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
