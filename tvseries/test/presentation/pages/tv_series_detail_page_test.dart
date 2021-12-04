import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tvseries/tvseries.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import '../../../../core/test/helpers/test_helper.dart';

void main() {
  late MockTvSeriesDetailBloc mockTvSeriesDetailBloc;
  late MockTvSeriesRecommendationBloc mockTvSeriesRecommendationBloc;
  late MockTvSeriesWatchlistBloc mockTvSeriesWatchlistBloc;

  setUpAll(() {
    registerFallbackValue(TvSeriesDetailEventFake());
    registerFallbackValue(TvSeriesDetailStateFake());
    registerFallbackValue(TvSeriesRecommendationEventFake());
    registerFallbackValue(TvSeriesRecommendationStateFake());
    registerFallbackValue(WatchlistTvSeriesEventFake());
    registerFallbackValue(WatchlistTvSeriesStateFake());
  });

  setUp(() {
    mockTvSeriesDetailBloc = MockTvSeriesDetailBloc();
    mockTvSeriesRecommendationBloc = MockTvSeriesRecommendationBloc();
    mockTvSeriesWatchlistBloc = MockTvSeriesWatchlistBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvSeriesDetailBloc>(
          create: (context) => mockTvSeriesDetailBloc,
        ),
        BlocProvider<TvSeriesRecommendationBloc>(
          create: (context) => mockTvSeriesRecommendationBloc,
        ),
        BlocProvider<WatchlistTvSeriesBloc>(
          create: (context) => mockTvSeriesWatchlistBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  const tId = 1;
  final tTvSeriesDetail = testTvSeriesDetail;
  final tTvSeriesList = testTvSeriesList;

  group('TV Series Detail', () {
    void _makeStubBloc() {
      when(() => mockTvSeriesWatchlistBloc.add(any())).thenReturn(null);
      when(() => mockTvSeriesRecommendationBloc.add(any())).thenReturn(null);
      when(() => mockTvSeriesWatchlistBloc.state)
          .thenReturn(WatchlistTvSeriesLoading());
      when(() => mockTvSeriesRecommendationBloc.state)
          .thenReturn(TvSeriesRecommendationLoading());
    }

    testWidgets('Page should display center progress bar when loading', (WidgetTester tester) async {
      when(() => mockTvSeriesDetailBloc.add(FetchTvSeriesDetail(tId))).thenReturn([]);
      when(() => mockTvSeriesDetailBloc.state).thenReturn(TvSeriesDetailLoading());
      final centerFinder = find.byType(Center);
      final circularFinder = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(
        id: tId,
      )));

      expect(centerFinder, findsOneWidget);
      expect(circularFinder, findsOneWidget);
    });

    testWidgets('Page should display detail content when data is loaded', (WidgetTester tester) async {
      when(() => mockTvSeriesDetailBloc.add(FetchTvSeriesDetail(tId)))
          .thenReturn(tTvSeriesDetail);
      when(() => mockTvSeriesDetailBloc.state)
          .thenReturn(TvSeriesDetailHasData(tTvSeriesDetail));
      _makeStubBloc();

      final safeAreaFinder = find.byType(SafeArea);
      final detailContentFinder = find.byType(DetailContent);

      await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(
        id: tId,
      )));

      expect(safeAreaFinder, findsOneWidget);
      expect(detailContentFinder, findsOneWidget);
    });

    testWidgets('Page should display text with message when Error', (WidgetTester tester) async {
      when(() => mockTvSeriesDetailBloc.state)
          .thenReturn(TvSeriesDetailError('Error'));

      final textFinder = find.byType(Text);

      await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(
        id: tId,
      )));

      expect(textFinder, findsOneWidget);
    });
  });

  group('TV Series Recommendation', () {
    void _makeStubBloc() {
      when(() => mockTvSeriesDetailBloc.add(FetchTvSeriesDetail(tId)))
          .thenReturn(tTvSeriesDetail);
      when(() => mockTvSeriesWatchlistBloc.add(any())).thenReturn(null);
      when(() => mockTvSeriesDetailBloc.state)
          .thenReturn(TvSeriesDetailHasData(tTvSeriesDetail));
      when(() => mockTvSeriesWatchlistBloc.state)
          .thenReturn(WatchlistTvSeriesLoading());
    }

    testWidgets('Page should display center progress bar when loading', (WidgetTester tester) async {
      _makeStubBloc();
      when(() => mockTvSeriesRecommendationBloc.state)
          .thenReturn(TvSeriesRecommendationLoading());

      final centerFinder = find.byKey(Key('center_tvr'));
      final progressBarFinder = find.byKey(Key('cpi_tvr'));

      await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(
        id: tId,
      )));

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('Page should display ListView when data is loaded', (WidgetTester tester) async {
      _makeStubBloc();
      when(() => mockTvSeriesRecommendationBloc.add(FetchTvSeriesRecommendation(tId)))
          .thenReturn(tTvSeriesDetail);
      when(() => mockTvSeriesRecommendationBloc.state)
          .thenReturn(TvSeriesRecommendationHasData(tTvSeriesList));

      final listViewFinder = find.byType(ListView);
      await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(
        id: tId,
      )));

      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('Page should display text with message when Error', (WidgetTester tester) async {
      _makeStubBloc();
      when(() => mockTvSeriesRecommendationBloc.state)
          .thenReturn(TvSeriesRecommendationError('Error Message'));

      final textFinder = find.byKey(Key('text_tvr'));
      await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(
        id: tId,
      )));

      expect(textFinder, findsOneWidget);
    });
  });

  group('Watchlist TV Series', () {
    void _makeStubBloc() {
      when(() => mockTvSeriesDetailBloc.add(FetchTvSeriesDetail(tId)))
          .thenReturn(tTvSeriesDetail);
      when(() => mockTvSeriesRecommendationBloc.add(any())).thenReturn(null);
      when(() => mockTvSeriesDetailBloc.state)
          .thenReturn(TvSeriesDetailHasData(tTvSeriesDetail));
      when(() => mockTvSeriesRecommendationBloc.state)
          .thenReturn(TvSeriesRecommendationLoading());
    }

    testWidgets('Page should display center progress bar when loading',
        (WidgetTester tester) async {
      _makeStubBloc();
      when(() => mockTvSeriesWatchlistBloc.add(LoadWatchlistTvSeriesStatus(tId)))
          .thenReturn(WatchlistTvSeriesLoading());
      when(() => mockTvSeriesWatchlistBloc.state)
          .thenReturn(WatchlistTvSeriesLoading());

      final centerFinder = find.byKey(Key('center_wltv'));
      final progressBarFinder = find.byKey(Key('cpi_wltv'));

      await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(
        id: tId,
      )));

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets(
        'Watchlist button should display check icon when tv is added to wathclist',
        (WidgetTester tester) async {
      _makeStubBloc();
      when(() => mockTvSeriesWatchlistBloc.add(SaveTvSeriesToWatchlist(tTvSeriesDetail)))
          .thenReturn(tTvSeriesDetail);
      when(() => mockTvSeriesWatchlistBloc.state)
          .thenReturn(WatchlistTvSeriesLoaded(true));

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(
        id: tId,
      )));

      expect(watchlistButtonIcon, findsOneWidget);
    });

    testWidgets(
        'Watchlist button should display add icon when tv not added to watchlist',
        (WidgetTester tester) async {
      _makeStubBloc();
      when(() => mockTvSeriesWatchlistBloc.add(RemoveTvSeriesFromWatchlist(
            tTvSeriesDetail,
          ))).thenReturn(tTvSeriesDetail);
      when(() => mockTvSeriesWatchlistBloc.state)
          .thenReturn(WatchlistTvSeriesLoaded(false));

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(
        id: tId,
      )));

      expect(watchlistButtonIcon, findsOneWidget);
    });

    testWidgets('Watchlist button should display ElevatedButton when add to watchlist failed', (WidgetTester tester) async {
      _makeStubBloc();
      when(() => mockTvSeriesWatchlistBloc.state)
          .thenReturn(WatchlistTvSeriesError('Error'));

      final textFinder = find.byKey(Key('error_wltv'));

      await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(
        id: tId,
      )));

      expect(textFinder, findsOneWidget);
    });
  });
}
