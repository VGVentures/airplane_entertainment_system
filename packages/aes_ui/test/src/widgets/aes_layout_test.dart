import 'package:aes_ui/aes_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('$AesLayout', () {
    testWidgets('renders successfully', (tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(),
          child: AesLayout(child: SizedBox()),
        ),
      );

      expect(find.byType(AesLayout), findsOneWidget);
    });

    group('of', () {
      testWidgets(
        'throws an $AssertionError if no $AesLayout is found in context',
        (tester) async {
          late final BuildContext buildContext;

          await tester.pumpWidget(
            Builder(
              builder: (context) {
                buildContext = context;
                return const SizedBox();
              },
            ),
          );

          expect(
            () => AesLayout.of(buildContext),
            throwsAssertionError,
          );
        },
      );

      testWidgets('returns the closest $AesLayoutData', (tester) async {
        const data = AesLayoutData.small;

        late final BuildContext buildContext;
        await tester.pumpWidget(
          AesLayout(
            data: data,
            child: Builder(
              builder: (context) {
                buildContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(AesLayout.of(buildContext), equals(data));
      });

      group('is small', () {
        testWidgets(
          'when the width is smaller than the mobile breakpoint',
          (tester) async {
            late final BuildContext buildContext;
            await tester.pumpWidget(
              MediaQuery(
                data: const MediaQueryData(
                  size: Size(AesLayout.mobileBreakpoint - 1, 200),
                ),
                child: AesLayout(
                  child: Builder(
                    builder: (context) {
                      buildContext = context;
                      return const SizedBox();
                    },
                  ),
                ),
              ),
            );

            expect(AesLayout.of(buildContext), equals(AesLayoutData.small));
          },
        );
      });

      group('is medium', () {
        testWidgets(
          'when the width is smaller than the desktop breakpoint',
          (tester) async {
            late final BuildContext buildContext;
            await tester.pumpWidget(
              MediaQuery(
                data: const MediaQueryData(
                  size: Size(AesLayout.desktopBreakpoint - 1, 200),
                ),
                child: AesLayout(
                  child: Builder(
                    builder: (context) {
                      buildContext = context;
                      return const SizedBox();
                    },
                  ),
                ),
              ),
            );

            expect(AesLayout.of(buildContext), equals(AesLayoutData.medium));
          },
        );
      });

      group('is large', () {
        testWidgets(
          'when the width is at the desktop breakpoint',
          (tester) async {
            late final BuildContext buildContext;
            await tester.pumpWidget(
              MediaQuery(
                data: const MediaQueryData(
                  size: Size(AesLayout.desktopBreakpoint, 200),
                ),
                child: AesLayout(
                  child: Builder(
                    builder: (context) {
                      buildContext = context;
                      return const SizedBox();
                    },
                  ),
                ),
              ),
            );

            expect(AesLayout.of(buildContext), equals(AesLayoutData.large));
          },
        );

        testWidgets(
          'when the width is greater than the desktop breakpoint',
          (tester) async {
            late final BuildContext buildContext;
            await tester.pumpWidget(
              MediaQuery(
                data: const MediaQueryData(
                  size: Size(AesLayout.desktopBreakpoint + 1, 200),
                ),
                child: AesLayout(
                  child: Builder(
                    builder: (context) {
                      buildContext = context;
                      return const SizedBox();
                    },
                  ),
                ),
              ),
            );

            expect(AesLayout.of(buildContext), equals(AesLayoutData.large));
          },
        );
      });

      testWidgets(
        'changes when the $MediaQueryData changes',
        (tester) async {
          BuildContext? buildContext;
          StateSetter? stateSetter;

          var data = const MediaQueryData(size: Size(100, 200));

          await tester.pumpWidget(
            StatefulBuilder(
              builder: (context, setState) {
                stateSetter ??= setState;
                return MediaQuery(
                  data: data,
                  child: AesLayout(
                    child: Builder(
                      builder: (context) {
                        buildContext ??= context;
                        return const SizedBox();
                      },
                    ),
                  ),
                );
              },
            ),
          );

          expect(AesLayout.of(buildContext!), equals(AesLayoutData.small));

          stateSetter!(() {
            data = const MediaQueryData(
              size: Size(AesLayout.mobileBreakpoint, 100),
            );
          });
          await tester.pumpAndSettle();

          expect(AesLayout.of(buildContext!), equals(AesLayoutData.medium));
        },
      );
    });
  });
}
