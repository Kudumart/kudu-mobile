import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/core/shared_widgets/app_button.dart';
import 'package:kudu/providers/store_viewmodel.dart';
import 'package:provider/provider.dart';

class AiProductCreatorModal extends StatefulWidget {
  const AiProductCreatorModal({super.key});

  static Future<Map<String, dynamic>?> show(BuildContext context) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const AiProductCreatorModal(),
    );
  }

  @override
  State<AiProductCreatorModal> createState() => _AiProductCreatorModalState();
}

class _AiProductCreatorModalState extends State<AiProductCreatorModal> {
  int _step = 1; // 1 = Type, 2 = Upload, 3 = Analyzing, 4 = Result Preview
  bool _isAuction = false;
  File? _imageFile;
  bool _isAnalyzing = false;
  Map<String, dynamic>? _aiResult;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() {
          _imageFile = File(picked.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Future<void> _runAiAnalysis() async {
    if (_imageFile == null) return;
    setState(() {
      _isAnalyzing = true;
      _step = 3;
    });

    final storeViewModel = Provider.of<StoreViewModel>(context, listen: false);
    final result = await storeViewModel.generateAiProductData(
      imageFile: _imageFile!,
      context: context,
    );

    if (mounted) {
      if (result != null) {
        setState(() {
          _aiResult = result;
          _isAnalyzing = false;
          _step = 4;
        });
      } else {
        setState(() {
          _isAnalyzing = false;
          _step = 2;
        });
      }
    }
  }

  void _applyToForm() {
    if (_aiResult == null) return;
    final Map<String, dynamic> finalData = Map<String, dynamic>.from(_aiResult!);
    finalData['isAuction'] = _isAuction;
    if (_imageFile != null) {
      finalData['imagePath'] = _imageFile!.path;
    }
    Navigator.pop(context, finalData);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.auto_awesome_rounded, color: AppUiColor.primary, size: 22),
                  SizedBox(width: 8),
                  Text(
                    "AI Product Creator",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(height: 20),

          // Stepper Progress Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              final stepNum = index + 1;
              final isActive = _step >= stepNum;
              return Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: isActive ? AppUiColor.primary : Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "$stepNum",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (stepNum < 4)
                    Container(
                      width: 32,
                      height: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      color: _step > stepNum ? AppUiColor.primary : Colors.grey.shade200,
                    ),
                ],
              );
            }),
          ),
          const SizedBox(height: 20),

          // STEP 1: Choose Listing Type
          if (_step == 1) ...[
            const Text(
              "Select Product Listing Type",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            const Text(
              "Our AI will analyze your product photo and automatically fill in your listing details.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isAuction = false;
                        _step = 2;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: !_isAuction ? AppUiColor.primary : Colors.grey.shade300,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white,
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.shopping_bag_outlined, color: AppUiColor.primary, size: 32),
                          SizedBox(height: 10),
                          Text(
                            "Fixed Price",
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Standard Product",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isAuction = true;
                        _step = 2;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _isAuction ? AppUiColor.primary : Colors.grey.shade300,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white,
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.gavel_rounded, color: AppUiColor.primary, size: 32),
                          SizedBox(height: 10),
                          Text(
                            "Live Auction",
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Accept Bids",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],

          // STEP 2: Upload Photo
          if (_step == 2) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => setState(() => _step = 1),
                icon: const Icon(Icons.arrow_back_rounded, size: 16),
                label: const Text("Back to Type Selection"),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Upload Photo for ${_isAuction ? 'Auction' : 'Fixed Price'} Product",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            if (_imageFile != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(_imageFile!, height: 180, width: double.infinity, fit: BoxFit.cover),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_outlined, size: 18),
                    label: const Text("Retake Camera"),
                  ),
                  const SizedBox(width: 12),
                  TextButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined, size: 18),
                    label: const Text("Choose Gallery"),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppButton(
                text: "✨ Analyze Product Photo",
                variant: AppButtonVariant.primary,
                onPressed: _runAiAnalysis,
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFFF9FAFB),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.cloud_upload_outlined, size: 48, color: AppUiColor.primary),
                    const SizedBox(height: 12),
                    const Text(
                      "Take or Select a Product Photo",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Clear photos yield the best AI auto-fill results",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _pickImage(ImageSource.camera),
                            icon: const Icon(Icons.camera_alt_rounded),
                            label: const Text("Camera"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _pickImage(ImageSource.gallery),
                            icon: const Icon(Icons.photo_library_rounded),
                            label: const Text("Gallery"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],

          // STEP 3: Analyzing State
          if (_step == 3) ...[
            const SizedBox(height: 30),
            const SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                strokeWidth: 3.5,
                color: AppUiColor.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "✨ AI is Analyzing Product Photo...",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            const Text(
              "Extracting title, description, category, and price recommendations",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 30),
          ],

          // STEP 4: AI Results Preview & Apply
          if (_step == 4 && _aiResult != null) ...[
            const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Text(
                  "AI Analysis Complete!",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AiPreviewRow(label: "Title:", value: _aiResult!['name'] ?? 'Not found'),
                  const Divider(height: 16),
                  _AiPreviewRow(
                    label: "Price:",
                    value: _aiResult!['suggestedPrice'] != null
                        ? "\$${_aiResult!['suggestedPrice']}"
                        : "Not specified",
                  ),
                  const Divider(height: 16),
                  _AiPreviewRow(label: "Description:", value: _aiResult!['description'] ?? 'Not found'),
                  if (_aiResult!['specifications'] != null) ...[
                    const Divider(height: 16),
                    _AiPreviewRow(label: "Specs:", value: _aiResult!['specifications']),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            AppButton(
              text: "✨ Apply Details to Listing Form",
              variant: AppButtonVariant.primary,
              onPressed: _applyToForm,
            ),
          ],
        ],
      ),
    );
  }
}

class _AiPreviewRow extends StatelessWidget {
  final String label;
  final String value;
  const _AiPreviewRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
      ],
    );
  }
}
