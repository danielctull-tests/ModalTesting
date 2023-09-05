
import SwiftUI

struct ContentView: View {


    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Child()
        }
        .modifier(ModalPresenterVM())
        .padding()
    }
}

struct Child: View {
    @Environment(\.modalPresenter) var present

    var body: some View {
        Button("Present") {
            present(Modal(item: "Child2") {
                Child2()
            })
        }
        .padding()
    }
}

struct Child2: View {
    @Environment(\.modalPresenter) var present

    var body: some View {
        Button("Replace") {
            present(Modal(item: "Goodbye:") {
                Text("GOODBYE")
            })
        }
        .padding()
    }

}

struct ModalKey: EnvironmentKey {
    static var defaultValue = ModalPresenter { _ in }
}

extension EnvironmentValues {
    var modalPresenter: ModalPresenter {
        get { self[ModalKey.self] }
        set { self[ModalKey.self] = newValue }
    }
}

struct ModalPresenter {
    let present: (Modal) -> Void
    func callAsFunction(_ modal: Modal) {
        present(modal)
    }
}


struct ModalPresenterVM: ViewModifier {

    @State var presented: Modal?

    func body(content: Content) -> some View {
        content
            .sheet(item: $presented) { modal in
                modal.view()
            }
            .environment(\.modalPresenter, ModalPresenter(present: { modal in
                presented = modal
            }))
    }
}

struct Modal: Identifiable {
    let id: ID
    struct ID: Hashable {
        let value: AnyHashable
    }

    init(item: some Hashable, view: @escaping () -> some View) {
        self.id = ID(value: AnyHashable(item))
        self.view = { AnyView(view()) }
    }

    let view: () -> AnyView
}
