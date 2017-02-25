//
//  DMCompanyDetailViewController.swift
//  Dominant Investors
//
//  Created by Nekit on 19.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit
import Alamofire

class DMCompanyDetailViewController: DMViewController, ChartViewDelegate {

    var company   : DMCompanyModel!
    var chartView : ChartView? = nil
    var chart     : SwiftStockChart!
    
    // MARK: Outlets
    @IBOutlet weak var infoLabel        : UILabel!
    @IBOutlet weak var infoTextLabel    : UILabel!
    @IBOutlet weak var companyNameLabel : UILabel!
    @IBOutlet weak var getSignalsButton : UIButton!
    @IBOutlet weak var companyLogo      : UIImageView!
    @IBOutlet weak var chartContainer   : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadChart()
    }
            
    // MARK : Private
    
    private func setupUI() {
        self.infoLabel.text        = self.company!.companyDescription
        self.companyLogo.image     = UIImage()
        self.companyNameLabel.text = self.company.name

        fillCompanyData()
    }
    
    private func fillCompanyData() {
        
        DMAPIService.sharedInstance.downloadCompanyLogoWith(ID: company.id) { (image) in
            DispatchQueue.main.async {
                self.companyLogo.image = image
            }
        }
        
        var annualSales_String = "Sector "
        annualSales_String = annualSales_String.appending(company.annualSales)
        annualSales_String = annualSales_String.appending("\n")
        
        let annualSales_atributed = NSMutableAttributedString(string: annualSales_String)
        annualSales_atributed.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: infoLabel.font.pointSize), range: NSRange(location:7,length:annualSales_atributed.length - 7))
        
        
        var IPO_String = "IPO Date "
        IPO_String = IPO_String.appending(company.IPODate)
        IPO_String = IPO_String.appending("\n")
        
        let IPO_atributed = NSMutableAttributedString(string: IPO_String)
        IPO_atributed.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: infoLabel.font.pointSize), range: NSRange(location:9,length:IPO_atributed.length-9))
        
        var averageSales_String = "Industry Group "
        averageSales_String = averageSales_String.appending(company.averageSales)
        averageSales_String = averageSales_String.appending("\n")
        
        let averageSales_atributed = NSMutableAttributedString(string: averageSales_String)
        averageSales_atributed.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: infoLabel.font.pointSize), range: NSRange(location:15,length:averageSales_atributed.length - 15))
        
        
        var marketCapitalization_string = "Market Capitalization "
        marketCapitalization_string = marketCapitalization_string.appending(company.marketCapitalization)
        marketCapitalization_string = marketCapitalization_string.appending("\n")
        
        let marketCapitalization_atributed = NSMutableAttributedString(string: marketCapitalization_string)
        marketCapitalization_atributed.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: infoLabel.font.pointSize), range: NSRange(location:22,length:marketCapitalization_atributed.length - 22))
        
        let potential_string = "Potential profitability " + company.potentialProfitability
        let potential_string_atributed = NSMutableAttributedString(string: potential_string)
        potential_string_atributed.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: infoLabel.font.pointSize), range: NSRange(location:24 ,length: potential_string_atributed.length - 24))
        
        IPO_atributed.append(marketCapitalization_atributed)
        IPO_atributed.append(annualSales_atributed)
        IPO_atributed.append(averageSales_atributed)
        IPO_atributed.append(potential_string_atributed)
        
        infoTextLabel.attributedText = IPO_atributed
    }
    
    
    private func loadChart() {

        chartView = ChartView.create()
        chartView?.delegate = self
        chartView?.frame = chartContainer.frame
        chartContainer?.addSubview(chartView!)
        
        chart = SwiftStockChart(frame: CGRect(x : 10, y :  10, width : self.view.frame.size.width-20, height : chartContainer.frame.size.height-70))
        
        chartView?.backgroundColor = UIColor.clear
        
        chart.axisColor = UIColor.red
        chart.verticalGridStep = 3
        
        loadChartWithRange(range: .OneDay)
        
        chartView?.addSubview(chart)
        chartView?.backgroundColor = UIColor.black
        
    
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()

    }
    
    // MARK : ChartViewDelegate
    
    func loadChartWithRange(range: ChartTimeRange) {
        
        chart.timeRange = range
        
        let times = chart.timeLabelsForTimeFrame(range: range)
        chart.horizontalGridStep = times.count - 1
        
        chart.labelForIndex = {(index: NSInteger) -> String in
            return times[index]
        }
        
        chart.labelForValue = {(value: CGFloat) -> String in
            return String(format: "%.02f", value)
        }
        
        SwiftStockKit.fetchChartPoints(symbol: self.company.ticker, range: range) { (chartPoints) -> () in
            self.chart.clearChartData()
            self.chart.setChartPoints(points: chartPoints)
        }
    }
    
    func didChangeTimeRange(range: ChartTimeRange) {
        loadChartWithRange(range: range)
    }

    // MARK : Actions
    
    @IBAction func showSignals(sender : UIButton) {
        self.performSegue(withIdentifier: "DMSignalsSegue", sender: self)
    }
    
    @IBAction func backButtonAction(sender : UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
