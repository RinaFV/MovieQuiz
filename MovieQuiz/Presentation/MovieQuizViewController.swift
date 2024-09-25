import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private let questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        
        if let firstQuestion = questionFactory.requestNextQuestion() {
            currentQuestion = firstQuestion
            let viewModel = convert(model: firstQuestion)
            show(quiz: viewModel)
        }
    }
    
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    struct ViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            showAlert()
        } else {
            currentQuestionIndex += 1
            
            if let nextQuestion = questionFactory.requestNextQuestion() {
                currentQuestion = nextQuestion
                let viewModel = convert(model: nextQuestion)
                
                show(quiz: viewModel)
            }
            
        }
    }
    private func showAlert () {
        let alert = UIAlertController(
            title: "Этот раунд окончен!",
            message: correctAnswers == questionsAmount ?
            "Поздравляем, вы ответили на 10 из 10!" :
                "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Сыграть ещё раз", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            if let firstQuestion = questionFactory.requestNextQuestion() {
                currentQuestion = firstQuestion
                let viewModel = convert(model: firstQuestion)
                show(quiz: viewModel)
            }
        }
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
        private func show(quiz result: QuizResultsViewModel) {
    let alert = UIAlertController(
        title: result.title,
        message: result.text,
        preferredStyle: .alert)
    
    let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
        self.currentQuestionIndex = 0
        self.correctAnswers = 0
        
        if let firstQuestion = self.questionFactory.requestNextQuestion() {
            self.currentQuestion = firstQuestion
            let viewModel = self.convert(model: firstQuestion)
            
            self.show(quiz: viewModel)
        }
    }

                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
            }
            
}

        
    
