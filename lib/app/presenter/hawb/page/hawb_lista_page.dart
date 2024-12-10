import 'package:flutter/material.dart';
import 'package:rt_flash/app/infra/lista/models/hawb_model.dart';

class HawbListaPage extends StatelessWidget {
  const HawbListaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<HawbModel> hawbs =
        ModalRoute.of(context)!.settings.arguments! as List<HawbModel>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RT'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            const SizedBox(height: 5),
            Center(
              child: Text(
                'Hawbs ativas',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 5),
            ListView.builder(
              shrinkWrap: true,
              itemCount: hawbs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(hawbs[index].codHawb ?? 'Hawb sem código'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
