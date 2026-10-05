import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sch_track/features/travel_crm/presentation/sections/pipeline/add_opportunity_dialog.dart';
import 'package:sch_track/features/travel_crm/presentation/sections/pipeline/crm_pipeline_section.dart';

void main() {
  Widget buildTestWidget() {
    return const ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: CrmPipelineSection(),
        ),
      ),
    );
  }

  group('CrmPipelineSection Widget & Integration Tests', () {
    testWidgets('Renders pipeline summary, toolbar, and 5 stage columns', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Verify Summary cards
      expect(find.text('opportunities'), findsOneWidget);
      expect(find.text('pipeline value'), findsOneWidget);
      expect(find.text('won this month'), findsOneWidget);

      // Verify 5 Stage Column Titles
      expect(find.text('New Enquiry'), findsWidgets);
      expect(find.text('Qualified'), findsWidgets);
      expect(find.text('Proposal Sent'), findsWidgets);
      expect(find.text('Negotiation'), findsWidgets);
      expect(find.text('Won'), findsWidgets);

      // Verify toolbar elements
      expect(find.text('Add Opportunity'), findsOneWidget);
    });

    testWidgets('Search query filters opportunity cards', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Enter search query
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'Meera');
      await tester.pumpAndSettle();

      expect(find.text('Meera Shah'), findsWidgets);
      expect(find.text('Clear Filters'), findsWidgets);
    });

    testWidgets('Add Opportunity dialog opens and validates required fields', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Tap Add Opportunity button
      await tester.tap(find.text('Add Opportunity'));
      await tester.pumpAndSettle();

      expect(find.text('Add Travel Opportunity'), findsOneWidget);

      // Tap Save without filling mandatory fields
      await tester.tap(find.text('Save Opportunity'));
      await tester.pumpAndSettle();

      // Verify validation errors
      expect(find.text('Contact name is required'), findsOneWidget);
      expect(find.text('Trip title is required'), findsOneWidget);
      expect(find.text('Destination is required'), findsOneWidget);
      expect(find.text('Estimated value is required'), findsOneWidget);

      // Fill invalid value (zero or negative or non-numeric)
      final dialogInputs = find.descendant(
        of: find.byType(AddOpportunityDialog),
        matching: find.byType(TextField),
      );
      await tester.enterText(dialogInputs.at(3), '-500');
      await tester.tap(find.text('Save Opportunity'));
      await tester.pumpAndSettle();

      expect(find.text('Must be a positive number'), findsOneWidget);
    });

    testWidgets('Empty search result displays empty filter state', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'NonExistentXYZ123');
      await tester.pumpAndSettle();

      expect(find.text('No opportunities match your search or filters'), findsOneWidget);

      // Tap Clear Filters button in empty state
      await tester.tap(find.text('Clear Filters').last);
      await tester.pumpAndSettle();

      expect(find.text('No opportunities match your search or filters'), findsNothing);
    });

    testWidgets('Narrow screen size does not cause overflow errors', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
