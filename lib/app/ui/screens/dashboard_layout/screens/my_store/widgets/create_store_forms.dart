part of '../screen.dart';

class _CreateStoreForms extends StatefulWidget {
  final Function(Store) onClickCreateStore;
  const _CreateStoreForms({required this.onClickCreateStore});

  @override
  State<_CreateStoreForms> createState() => _CreateStoreFormsState();
}

class _CreateStoreFormsState extends State<_CreateStoreForms> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _values = {};
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 60, 18, 10),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text(
              "Create your Store",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 38),
            _CustomOutlinedTextField(
                label: "Store Name",
                validator: InputValidator.validateValidInput,
                hint: "Enter your store name",
                onSaved: (name) => _values["name"] = name),
            const SizedBox(height: 20),
            _CustomOutlinedTextField(
                label: "Address",
                validator: InputValidator.validateValidInput,
                hint: "Enter your address",
                onSaved: (address) => _values["address"] = address),
            const SizedBox(height: 20),
            _CustomOutlinedDropdownField(
                label: "Country",
                values: const [
                  "Nigeria",
                  "Canada",
                  "United States",
                  "United Kingdom"
                ],
                onSelect: (country) => _values["country"] = country),
            const SizedBox(height: 20),
            _CustomOutlinedDropdownField(
                label: "State",
                values: const ["Lagos", "Ontario", "Iyana Ontario", "New York"],
                onSelect: (chosen) => _values["state"] = chosen),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: _createStore,
              child: const Text("Create Store"),
            )
          ],
        ),
      ),
    );
  }

  _createStore() {
    _formKey.currentState!.save();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    context.pop();
    final store = Store.fromJson(_values);
    widget.onClickCreateStore(store);
  }
}
