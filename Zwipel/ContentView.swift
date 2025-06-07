//
//  ContentView.swift
//  Zwipel2
//
//  Created by Ivan on 21.05.2025.


import SwiftUI

struct ContentView: View {
    @EnvironmentObject var clipboardManager: ClipboardManager

    var body: some View {
        VStack(spacing: 0) {
            SearchBarView(text: $clipboardManager.searchText)
            
            Divider()

            if clipboardManager.filteredAndSortedHistory.isEmpty {
                if clipboardManager.searchText.isEmpty {
                    Text("История буфера обмена пуста")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Text("Ничего не найдено")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } else {
                List {
                    ForEach(clipboardManager.filteredAndSortedHistory) { item in
                        ClipboardRowView(item: item)
                    }
                }
                .listStyle(.plain)
            }
            
            FooterView()
        }
    }
}

struct ClipboardRowView: View {
    @EnvironmentObject var clipboardManager: ClipboardManager
    let item: ClipboardItem

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.content)
                    .lineLimit(2)
                    .truncationMode(.tail)
                Text(item.createdAt, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: {
                    clipboardManager.togglePin(for: item)
                }) {
                    Image(systemName: item.isPinned ? "pin.fill" : "pin")
                        .foregroundColor(item.isPinned ? .accentColor : .secondary)
                }
                .buttonStyle(.plain)
                
                Button(action: {
                    clipboardManager.deleteItem(item: item)
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            clipboardManager.copyToClipboard(item: item)
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                clipboardManager.togglePin(for: item)
            } label: {
                Label(item.isPinned ? "Открепить" : "Закрепить", systemImage: "pin.fill")
            }
            .tint(item.isPinned ? .gray : .accentColor)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                clipboardManager.deleteItem(item: item)
            } label: {
                Label("Удалить", systemImage: "trash")
            }
        }
        .contextMenu {
            Button { clipboardManager.copyToClipboard(item: item) } label: { Label("Копировать", systemImage: "doc.on.doc") }
            Button { clipboardManager.togglePin(for: item) } label: { Label(item.isPinned ? "Открепить" : "Закрепить", systemImage: "pin") }
            Divider()
            Button(role: .destructive) { clipboardManager.deleteItem(item: item) } label: { Label("Удалить", systemImage: "trash") }
        }
    }
}


struct SearchBarView: View {
    @Binding var text: String
    var body: some View {
        HStack {
            TextField("Поиск по истории...", text: $text)
                .textFieldStyle(.plain)
                .padding(7)
                .padding(.horizontal, 25)
                .cornerRadius(8)
                .overlay( HStack {
                    Image(systemName: "magnifyingglass").foregroundColor(.gray).frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).padding(.leading, 8)
                    if !text.isEmpty {
                        Button(action: { self.text = "" }) { Image(systemName: "multiply.circle.fill").foregroundColor(.gray).padding(.trailing, 8) }.buttonStyle(.plain)
                    }
                })
        }.padding(.horizontal).padding(.vertical, 8)
    }
}

struct FooterView: View {
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                Text("Zwipel v0.3")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Spacer()
                Button("Выход") { NSApplication.shared.terminate(nil) }
            }.padding()
        }
    }
}
