import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tvseries/tvseries.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';

class MockTopRatedTvSeriesBloc
    extends MockBloc<TopRatedTvSeriesEvent, TopRatedTvSeriesState>
    implements TopRatedTvSeriesBloc {}

class TopRatedTvSeriesEventFake extends TopRatedTvSeriesEvent {}
class TopRatedTvSeriesStateFake extends TopRatedTvSeriesState {}

void main() {
  late MockTopRatedTvSeriesBloc mockTopRatedTvSeriesBloc;

  setUpAll(() {
    registerFallbackValue(TopRatedTvSeriesEventFake());
    registerFallbackValue(TopRatedTvSeriesStateFake());
  });

  setUp(() {
    mockTopRatedTvSeriesBloc = MockTopRatedTvSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TopRatedTvSeriesBloc>(
            create: (context) => mockTopRatedTvSeriesBloc),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  final tTvSeriesList = testTvSeriesList;

  group('Top Rated TV Series Page', () {
    testWidgets('Page should display center progress bar when loading',
            (WidgetTester tester) async {
          when(() => mockTopRatedTvSeriesBloc.state).thenReturn(TopRatedTvSeriesLoading());

          final progressBarFinder = find.byType(CircularProgressIndicator);
          final centerFinder = find.byType(Center);

          await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

          expect(progressBarFinder, findsOneWidget);
          expect(centerFinder, findsOneWidget);
        });

    testWidgets('Page should display ListView when data is loaded',
            (WidgetTester tester) async {
          when(() => mockTopRatedTvSeriesBloc.state)
              .thenReturn(TopRatedTvSeriesHasData(tTvSeriesList));

          final listViewFinder = find.byType(ListView);

          await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

          expect(listViewFinder, findsOneWidget);
        });

    testWidgets('Page should display text with message when Error',
            (WidgetTester tester) async {
          when(() => mockTopRatedTvSeriesBloc.state)
              .thenReturn(TopRatedTvSeriesError('Error message'));

          final textFinder = find.text("Error message");
          await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

          expect(textFinder, findsOneWidget);
        });
  });
}
