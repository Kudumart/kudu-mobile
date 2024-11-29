part of '../screen.dart';

class _FaqBanner extends StatelessWidget {
  const _FaqBanner();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => const FAQScreenRoute().push(context),
      child: Container(
          height: 100,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          constraints: const BoxConstraints(
            minWidth: 150,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFFDEC1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            children: [
              Image.asset(AppUiImage.faq2,
                  width: 66, height: 49, fit: BoxFit.contain),
              const Expanded(
                child: Text(
                  "Frequently Asked Questions",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
              )
            ],
          )),
    );
  }
}

class _PoliciesBanner extends StatelessWidget {
  const _PoliciesBanner();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => const PrivacyPolicyScreenRoute().push(context),
      child: Container(
          height: 100,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          constraints: const BoxConstraints(minWidth: 150),
          decoration: BoxDecoration(
            color: const Color(0xFF9DA0C1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            children: [
              Image.asset(AppUiImage.docPolicy,
                  width: 66, height: 49, fit: BoxFit.contain),
              const Text(
                "Our Policies",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              )
            ],
          )),
    );
  }
}
