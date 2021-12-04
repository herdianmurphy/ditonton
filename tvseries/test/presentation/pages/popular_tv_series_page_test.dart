import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tvseries/tvseries.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import '../../../../core/test/helpers/test_helper.dart';

void main() {
  late MockPopularTvSeriesBloc mockPopularTvSeriesBloc;

  setUpAll(() {
    registerFallbackValue(PopularTvSeriesEventFake());
    registerFallbackValue(PopularTvSeriesStateFake());
  });

  setUp(() {
    mockPopularTvSeriesBloc = MockPopularTvSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PopularTvSeriesBloc>(
            create: (context) => mockPopularTvSeriesBloc),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  final tTvSeriesList = testTvSeriesList;

  group('Popular TvSeries Page', () {
    testWidgets('Page should display center progress bar when loading',
            (WidgetTester tester) async {
          when(() => mockPopularTvSeriesBloc.state).thenReturn(PopularTvSeriesLoading());

          final progressBarFinder = find.byType(CircularProgressIndicator);
          final centerFinder = find.byType(Center);

          await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

          expect(progressBarFinder, findsOneWidget);
          expect(centerFinder, findsOneWidget);
        });

    testWidgets('Page should display ListView when data is loaded',
            (WidgetTester tester) async {
          when(() => mockPopularTvSeriesBloc.state)
              .thenReturn(PopularTvSeriesHasData(tTvSeriesList));

          final listViewFinder = find.byType(ListView);

          await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

          expect(listViewFinder, findsOneWidget);
        });

    testWidgets('Page should display text with message when Error',
            (WidgetTester tester) async {
          when(() => mockPopularTvSeriesBloc.state)
              .thenReturn(PopularTvSeriesError('Error message'));

          final textFinder = find.text("Error message");
          await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

          expect(textFinder, findsOneWidget);
        });
  });
}
