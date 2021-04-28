import Foundation
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

class DataFetcher {
  private var currentPage = 0

  lazy var pageSubject: AnyPublisher<Data, Never> = {
    pageRequest
      .flatMap({ _ -> URLSession.DataTaskPublisher in
        let url = URL(string: "https://www.kasprasolutions.com")!
        return URLSession.shared.dataTaskPublisher(for: url)
    })
    .catch({ _ in
      Empty()
    })
    .map(\.data)
  .eraseToAnyPublisher()
  }()

  let pageRequest = PassthroughSubject<Void, Never>()

  func loadNextPage() {
    pageRequest.send(())
  }
}

let fetcher = DataFetcher()
var cancellables = Set<AnyCancellable>()

fetcher.pageSubject.sink(receiveValue: { data in
  print(data)
})
.store(in: &cancellables)

fetcher.loadNextPage()
fetcher.loadNextPage()
