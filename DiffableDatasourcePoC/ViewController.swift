//
//  ViewController.swift
//  DiffableDatasourcePoC
//
//  Created by Amin Siddiqui on 14/10/23.
//

import UIKit

enum Section {
    case number
}

class ViewController: UIViewController {
    
    static var cellIdentifier = "cell"
    
    var numbers = [1,2,3,4,5]
    @IBOutlet var normalTableView: UITableView!
    
    @IBOutlet var diffableTableView: UITableView!
    var diffableDatasource: UITableViewDiffableDataSource<Section, Int>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNormalTableView()
        setupDiffableExample()
    }
    
    @IBAction func refresh() {
        let newNumbers = Array((1...10).shuffled().prefix(5))
        let compareSet = Set(newNumbers)
        let added = compareSet.subtracting(numbers).sorted()
        let same = compareSet.intersection(numbers).sorted()
        
        print("###")
        print("old", numbers.sorted())
        print("new", newNumbers.sorted())
        print("###", same, "+", added)
        
        refreshNormalTableView(with: newNumbers)
        refreshDiffableTableView(with: newNumbers)
    }
}

extension ViewController: UITableViewDataSource {
    
    func setupNormalTableView() {
        normalTableView.dataSource = self
        refreshNormalTableView(with: numbers)
    }
    
    private func refreshNormalTableView(with numbers: [Int]) {
        self.numbers = numbers
        
        let indexPaths = numbers.enumerated().map { index, _ in IndexPath(row: index, section: 0) }
        normalTableView.reloadRows(at: indexPaths, with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath)
        
        let number = numbers[indexPath.row]
        cell.textLabel?.text = "\(number)"
        
        print("Normal:", number)
        return cell
    }
}

extension ViewController {
    
    func setupDiffableExample() {
        diffableDatasource = UITableViewDiffableDataSource<Section, Int>(tableView: diffableTableView) { tableView, indexPath, number in
            let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath)
            
            cell.textLabel?.text = "\(number)"
            
            print("Diffable:", number)
            return cell
        }
        
        refreshDiffableTableView(with: numbers)
    }
    
    func refreshDiffableTableView(with newNumbers: [Int]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section,Int>()
        snapshot.appendSections([.number])
        snapshot.appendItems(newNumbers, toSection: .number)
        diffableDatasource.apply(snapshot)
    }
}

