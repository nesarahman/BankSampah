import 'package:flutter/material.dart';
import 'pemilik_data.dart';

class PemilikNasabahView extends StatefulWidget {
  const PemilikNasabahView({super.key});

  @override
  State<PemilikNasabahView> createState() => _PemilikNasabahViewState();
}

class _PemilikNasabahViewState extends State<PemilikNasabahView> {
  String _q = '';

  void _cairkan(int ni) {
    final d = PemilikData.I;
    final n = d.nasabah[d.unit][ni];
    final c = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Cairkan Saldo ${n['nama']}'),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Saldo: ${rp(n['saldo'] as int)}', style: const TextStyle(color: kGreen, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextField(
            controller: c,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(prefixText: 'Rp ', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kGreen),
            onPressed: () {
              final v = int.tryParse(c.text.trim()) ?? 0;
              final msg = v < 10000
                  ? 'Minimal pencairan Rp 10.000'
                  : v > (n['saldo'] as int)
                      ? 'Nominal melebihi saldo nasabah'
                      : null;
              Navigator.pop(ctx);
              if (msg == null) d.cairkan(ni, v);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(msg ?? '${rp(v)} dicairkan ke ${n['nama']}.'),
                backgroundColor: msg == null ? kGreen : Colors.red,
              ));
            },
            child: const Text('Cairkan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: PemilikData.I,
      builder: (context, _) {
        final d = PemilikData.I;
        final all = d.nasabah[d.unit];
        final idx = [for (var i = 0; i < all.length; i++) if ('${all[i]['nama']}'.toLowerCase().contains(_q.toLowerCase().trim())) i];
        final totalSaldo = all.fold<int>(0, (a, n) => a + (n['saldo'] as int));

        return Scaffold(
          backgroundColor: kBg,
          appBar: pemilikAppBar(),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Nasabah ${d.unitAktif['singkat']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Total saldo ${rp(totalSaldo)}', style: const TextStyle(fontSize: 11, color: kGreen, fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 10),
              TextField(
                onChanged: (v) => setState(() => _q = v),
                decoration: InputDecoration(
                  hintText: 'Cari nama nasabah',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              ...idx.map((i) {
                final n = all[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: cardDeco(),
                  child: Row(children: [
                    CircleAvatar(backgroundColor: kSoft, child: Text('${n['nama']}'.substring(0, 1), style: const TextStyle(color: kGreen, fontWeight: FontWeight.bold))),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${n['nama']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('${n['hp']} • ${(n['kg'] as double).toStringAsFixed(1)} kg disetor', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        const SizedBox(height: 2),
                        Text(rp(n['saldo'] as int), style: const TextStyle(fontWeight: FontWeight.w900, color: kGreen, fontSize: 14)),
                      ]),
                    ),
                    OutlinedButton(
                      onPressed: () => _cairkan(i),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: kGreen), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: const Text('Cairkan', style: TextStyle(color: kGreen, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ]),
                );
              }),
              if (idx.isEmpty) const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('Nasabah tidak ditemukan', style: TextStyle(color: Colors.grey)))),
            ],
          ),
        );
      },
    );
  }
}
