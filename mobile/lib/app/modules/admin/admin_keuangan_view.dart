import 'package:flutter/material.dart';

class AdminKeuanganView extends StatefulWidget {
  final bool showAppBar;
  const AdminKeuanganView({super.key, this.showAppBar = true});

  @override
  State<AdminKeuanganView> createState() => _AdminKeuanganViewState();
}

class _AdminKeuanganViewState extends State<AdminKeuanganView> {
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color darkGreen = Color(0xFF0D631B);
  static const Color bgSurface = Color(0xFFF9F9FF);

  String _currentTab = 'review'; // 'review' atau 'history'

  List<Map<String, dynamic>> _pendingRequests = [];
  List<Map<String, dynamic>> _historyRequests = [];

  @override
  void initState() {
    super.initState();
    _pendingRequests = [
      {
        'id': '1',
        'code': '#W-34891',
        'name': 'Rizky Pratama',
        'initials': 'RP',
        'tag': 'Kilat',
        'tagColor': const Color(0xFF2E7D32),
        'bank': 'BCA',
        'accountNumber': '438192801',
        'accountName': 'Rizky Pratama',
        'amount': 150000,
        'remainingBalance': 198500,
        'receiptUploaded': false,
        'receiptName': 'struk_transfer_berhasil.png',
        'receiptInfo': 'Terunggah • 842 KB • Siap verifikasi',
      },
      {
        'id': '2',
        'code': '#W-35102',
        'name': 'Siti Aisyah',
        'initials': 'SA',
        'tag': 'Reguler',
        'tagColor': Colors.blue.shade700,
        'bank': 'Mandiri',
        'accountNumber': '070019283412',
        'accountName': 'Siti Aisyah',
        'amount': 200000,
        'remainingBalance': 15000,
        'receiptUploaded': false,
        'receiptName': 'struk_transfer_berhasil.png',
        'receiptInfo': 'Terunggah • 620 KB • Siap verifikasi',
      },
      {
        'id': '3',
        'code': '#W-36219',
        'name': 'Dani Setiawan',
        'initials': 'DS',
        'tag': 'GoPay',
        'tagColor': Colors.green.shade800,
        'bank': 'GoPay',
        'accountNumber': '0812-4481-2022',
        'accountName': 'Dani Setiawan',
        'amount': 50000,
        'remainingBalance': 4200,
        'receiptUploaded': false,
        'receiptName': 'struk_transfer_berhasil.png',
        'receiptInfo': 'Terunggah • 512 KB • Siap verifikasi',
      },
    ];

    _historyRequests = [
      {
        'id': '101',
        'code': '#W-33100',
        'name': 'Budi Santoso',
        'initials': 'BS',
        'bank': 'BRI',
        'accountNumber': '0129-01-098234-50-1',
        'amount': 75000,
        'date': 'Kemarin, 14:20 WIT',
        'status': 'Selesai Ditransfer',
      },
      {
        'id': '102',
        'code': '#W-32904',
        'name': 'Dewi Lestari',
        'initials': 'DL',
        'bank': 'BNI',
        'accountNumber': '0928341290',
        'amount': 120000,
        'date': '10 Okt 2026 • 11:00 WIT',
        'status': 'Selesai Ditransfer',
      },
      {
        'id': '103',
        'code': '#W-31805',
        'name': 'Ahmad Fauzi (Kurir)',
        'initials': 'AF',
        'bank': 'Mandiri',
        'accountNumber': '1420019823412',
        'amount': 380500,
        'date': '8 Okt 2026 • 16:45 WIT',
        'status': 'Selesai Ditransfer',
      },
    ];
  }

  int get _totalPendingAmount {
    int total = 0;
    for (var r in _pendingRequests) {
      total += (r['amount'] as int);
    }
    return total;
  }

  String _formatRupiah(int val) {
    final s = val.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write('.');
      buffer.write(s[i]);
    }
    return 'Rp $buffer';
  }

  void _simulateUpload(Map<String, dynamic> req) {
    setState(() {
      req['receiptUploaded'] = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: primaryGreen,
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text('Struk transfer untuk ${req['name']} berhasil diunggah!'),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _approveRequest(Map<String, dynamic> req) {
    if (req['receiptUploaded'] != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade700,
          content: Row(
            children: [
              const Icon(Icons.warning, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Mohon unggah struk mutasi transfer terlebih dahulu untuk penarikan ${req['name']}.',
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Persetujuan'),
        content: Text(
          'Setujui transfer ${_formatRupiah(req['amount'] as int)} ke rekening ${req['bank']} a.n ${req['accountName']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _pendingRequests.removeWhere((r) => r['id'] == req['id']);
                _historyRequests.insert(0, {
                  'id': req['id'],
                  'code': req['code'],
                  'name': req['name'],
                  'initials': req['initials'],
                  'bank': req['bank'],
                  'accountNumber': req['accountNumber'],
                  'amount': req['amount'],
                  'date': 'Baru saja',
                  'status': 'Selesai Ditransfer',
                });
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: primaryGreen,
                  content: Text('Penarikan dana untuk ${req['name']} berhasil disetujui!'),
                ),
              );
            },
            child: const Text('Setujui & Kirim'),
          ),
        ],
      ),
    );
  }

  void _rejectRequest(Map<String, dynamic> req) {
    final reasonController = TextEditingController(text: 'Nomor rekening tidak terdaftar / salah input');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Tolak Penarikan ${req['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukkan alasan penolakan untuk dikirim ke nasabah:',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: reasonController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Alasan penolakan...',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _pendingRequests.removeWhere((r) => r['id'] == req['id']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red.shade700,
                  content: Text('Penarikan dana untuk ${req['name']} telah ditolak.'),
                ),
              );
            },
            child: const Text('Tolak Permohonan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgSurface,
      appBar: widget.showAppBar
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              title: const Text(
                'Admin Verifikasi Saldo',
                style: TextStyle(
                  color: Color(0xFF121C2C),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                ),
              ],
            )
          : null,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Live Header context badge
                _buildLiveContextBadge(),
                const SizedBox(height: 14),

                // Escrow Card
                _buildEscrowCard(),
                const SizedBox(height: 16),

                // Segmented Control Tabs
                _buildSegmentedTabs(),
                const SizedBox(height: 16),

                // Tab Content
                if (_currentTab == 'review') ...[
                  if (_pendingRequests.isEmpty)
                    _buildEmptyQueueState()
                  else
                    ..._pendingRequests.map((req) => _buildWithdrawalCard(req)),
                ] else ...[
                  ..._historyRequests.map((hist) => _buildHistoryCard(hist)),
                ],

                const SizedBox(height: 16),

                // Security Protocol Banner
                _buildSecurityProtocolBanner(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLiveContextBadge() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE7EEFF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: primaryGreen,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'ANTREAN ADMIN LIVE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: primaryGreen,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              'Hari ini, 15 Okt',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEscrowCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryGreen, darkGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withOpacity(0.3),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'REKENING PENAMPUNG REGREEN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFA3F69C),
                  letterSpacing: 0.5,
                ),
              ),
              Icon(Icons.verified_user, color: Color(0xFFA3F69C), size: 18),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Total Dana Siap Cair Hari Ini',
            style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.85)),
          ),
          const SizedBox(height: 2),
          Text(
            _formatRupiah(_totalPendingAmount),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.assured_workload, color: Color(0xFFA3F69C), size: 14),
                  SizedBox(width: 6),
                  Text(
                    'Bank Mandiri Giro Escrow',
                    style: TextStyle(fontSize: 11, color: Color(0xFFA3F69C)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_pendingRequests.length} Permintaan Menunggu',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFDEE8FF),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _currentTab = 'review'),
              borderRadius: BorderRadius.circular(25),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: _currentTab == 'review' ? primaryGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Menunggu Review',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: _currentTab == 'review' ? Colors.white : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: _currentTab == 'review' ? Colors.white : primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${_pendingRequests.length}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _currentTab == 'review' ? primaryGreen : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _currentTab = 'history'),
              borderRadius: BorderRadius.circular(25),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: _currentTab == 'history' ? primaryGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Riwayat Transfer',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: _currentTab == 'history' ? Colors.white : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '(${_historyRequests.length})',
                      style: TextStyle(
                        fontSize: 11,
                        color: _currentTab == 'history' ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyQueueState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Column(
        children: [
          Icon(Icons.task_alt, color: primaryGreen, size: 48),
          SizedBox(height: 12),
          Text(
            'Semua Penarikan Selesai!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF121C2C),
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Tidak ada permintaan penarikan saldo yang menunggu review saat ini.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildWithdrawalCard(Map<String, dynamic> req) {
    final bool uploaded = req['receiptUploaded'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Profile & Badge
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFE8F5E9),
                child: Text(
                  req['initials'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryGreen,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          req['name'] as String,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF121C2C),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          req['code'] as String,
                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${req['bank']} • ${req['accountNumber']} a.n ${req['accountName']}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (req['tagColor'] as Color).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  req['tag'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: req['tagColor'] as Color,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 10),

          // Row 2: Amount & Remaining balance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nominal Penarikan',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatRupiah(req['amount'] as int),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Sisa Saldo Akun',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatRupiah(req['remainingBalance'] as int),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF121C2C),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Upload Struk Slot
          InkWell(
            onTap: () => _simulateUpload(req),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: uploaded ? const Color(0xFFE8F5E9) : const Color(0xFFF0F3FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: uploaded ? primaryGreen : Colors.grey.shade300,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    uploaded ? Icons.task : Icons.upload_file,
                    color: uploaded ? primaryGreen : Colors.grey[700],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          uploaded ? (req['receiptName'] as String) : 'Unggah Bukti Struk Transfer (Wajib)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: uploaded ? primaryGreen : const Color(0xFF121C2C),
                          ),
                        ),
                        Text(
                          uploaded ? (req['receiptInfo'] as String) : 'JPG, PNG, atau PDF (Maks. 2MB)',
                          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    uploaded ? Icons.check_circle : Icons.attach_file,
                    color: uploaded ? primaryGreen : Colors.grey,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Action Buttons: Tolak vs Setujui & Transfer
          Row(
            children: [
              Expanded(
                flex: 2,
                child: OutlinedButton.icon(
                  onPressed: () => _rejectRequest(req),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade700,
                    side: BorderSide(color: Colors.red.shade300),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.close, size: 16),
                  label: const Text(
                    'Tolak',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: ElevatedButton.icon(
                  onPressed: () => _approveRequest(req),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 1,
                  ),
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text(
                    'Setujui & Transfer',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> hist) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFE8F5E9),
            child: Text(
              hist['initials'] as String,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryGreen,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      hist['name'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF121C2C),
                      ),
                    ),
                    Text(
                      _formatRupiah(hist['amount'] as int),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: primaryGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${hist['bank']} • ${hist['accountNumber']}',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                    Text(
                      hist['date'] as String,
                      style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityProtocolBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F3FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD9E3F9)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.policy, color: Color(0xFF2E7D32), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Protokol Keamanan Admin REGREEN',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF121C2C),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Pastikan nomor rekening dan nama pemilik bank tujuan sama persis dengan profil akun nasabah sebelum menyetujui mutasi dana.',
                  style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
