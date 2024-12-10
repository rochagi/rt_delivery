import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_flash/app/presenter/login/cubits/master_key/master_key_cubit.dart';
import 'package:rt_flash/app/shared/widgets/buttons/custom_elevated_button.dart';

class MasterKeyForm extends StatefulWidget {
  const MasterKeyForm({super.key});

  @override
  State<MasterKeyForm> createState() => _MasterKeyFormState();
}

class _MasterKeyFormState extends State<MasterKeyForm> {
  late TextEditingController _masterKeyInput;

  @override
  void initState() {
    _masterKeyInput = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const SizedBox(
            height: 80,
          ),
          TextFormField(
            controller: _masterKeyInput,
            onChanged: (value) {
              setState(() {
                _masterKeyInput;
              });
            },
            decoration:
                const InputDecoration(labelText: 'Insira a senha master'),
          ),
          const SizedBox(height: 20),
          CustomElevatedButton(
            title: 'Verificar',
            onTap: _masterKeyInput.text.isEmpty
                ? null
                : () => context
                    .read<MasterKeyCubit>()
                    .checkMasterKey(masterKey: _masterKeyInput.text),
          )
        ],
      ),
    );
  }
}
