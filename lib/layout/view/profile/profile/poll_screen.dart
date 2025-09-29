import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:my_academy/layout/view/profile/managers/contact_support_service_cubit.dart';

class PollScreen extends StatefulWidget {
  const PollScreen({super.key});

  @override
  State<PollScreen> createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  Map<int, int> selectedAnswers = {};
  int currentQuestionIndex = 0;

  @override
  void initState() {
    context.read<ContactSupportServiceCubit>().getAllPolls();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5B800),
      body: BlocConsumer<ContactSupportServiceCubit, ContactSupportServiceState>(
        listener: (context, state) {
          if (state is SubmitPollAnswerSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );

            final cubit = context.read<ContactSupportServiceCubit>();
            if (cubit.pollsData?.data?.questions != null) {
              if (currentQuestionIndex < cubit.pollsData!.data!.questions!.length - 1) {
                setState(() {
                  currentQuestionIndex++;
                });
              } else {
                _showCompletionDialog(context);
              }
            }
          } else if (state is SubmitPollAnswerErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? tr('error_occurred')),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GetAllPollsLoadingState) {
            return _buildLoadingState();
          }

          if (state is GetAllPollsSuccessState) {
            if (state.questions.isEmpty) {
              return _buildEmptyState(context);
            }

            return _buildPollContent(context, state, selectedAnswers);
          }

          if (state is GetAllPollsErrorState) {
            return _buildErrorState(context);
          }

          return _buildLoadingState();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/empty_poll.png',
                    width: 200,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.poll_outlined,
                        size: 100,
                        color: Colors.white70,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    tr('no_polls_available'),
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.white70,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    tr('polls_error'),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<ContactSupportServiceCubit>().getAllPolls();
                    },
                    icon: const Icon(Icons.refresh, color: Color(0xFFF5B800)),
                    label: Text(
                      tr('retry'),
                      style: const TextStyle(color: Color(0xFFF5B800)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPollContent(
      BuildContext context,
      GetAllPollsSuccessState state,
      Map<int, int> selectedAnswers,
      ) {
    final questions = state.questions;
    final allAnswers = state.answers;

    if (questions.isEmpty) {
      return Center(child: Text(tr('no_questions_available')));
    }

    return SafeArea(
      child: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: questions.length,
              itemBuilder: (context, questionIndex) {
                final question = questions[questionIndex];
                final questionAnswers = allAnswers.toList();

                return Card(
                  margin: const EdgeInsets.only(bottom: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question.title ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...questionAnswers.map((answer) {
                          return RadioListTile<int>(
                            title: Text(answer.title ?? ''),
                            value: answer.id!,
                            groupValue: selectedAnswers[question.id],
                            onChanged: (value) {
                              setState(() {
                                selectedAnswers[question.id!] = value!;
                              });
                            },
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                final cubit = context.read<ContactSupportServiceCubit>();

                if (selectedAnswers.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(tr('choose_one_answer')),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                cubit.submitAllPollAnswers(selectedAnswers);

                _showCompletionDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5B800),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                tr('submit_all_answers'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          Expanded(
            child: Text(
              tr('polls'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // يمنع إنه يقفل بالضغط برا
      builder: (context) => WillPopScope(
        onWillPop: () async => false, // يمنع رجوع الباك
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5B800).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 60,
                  color: Color(0xFFF5B800),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                tr('submission_success'),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                tr('thanks_for_participation'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF5B800),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  tr('back_home'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
