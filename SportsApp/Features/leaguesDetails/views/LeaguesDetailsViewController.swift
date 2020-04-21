//
//  LeaguesDetailsViewController.swift
//  SportsApp
//
//  Created by Esraa Hassan on 4/20/20.
//  Copyright © 2020 eman kamal. All rights reserved.
//

import UIKit

class LeaguesDetailsViewController: UIViewController, LeaguesDetailsViewDelegate {
    
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var upcomingCollectionView: UICollectionView!
    @IBOutlet weak var latestCollectionView: UICollectionView!
    @IBOutlet weak var teamsCollectionView: UICollectionView!

    var upComingFlowLayout : UICollectionViewFlowLayout!
    var latestViewFlowLayout : UICollectionViewFlowLayout!
    var league : League?
    var nextEvents = [Event]()
    var leagueDetailsPresenter :LeaguesDetailsPresenter?
    let leagueDetailsSubscriber = LeaguesDetailsSubscriber()
    var latestEvents = [Event]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var teamsFlowLayout : UICollectionViewFlowLayout!
    var teams = [Team]()
    var notFavImage = UIImage(named: "notfav.png")
    var favImage = UIImage(named: "fav.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leagueDetailsPresenter = LeaguesDetailsPresenter.init(coreData: appDelegate.localLeagues!)
    
        leagueDetailsSubscriber.attachView(view: self)
        leagueDetailsPresenter!.getNextEvents()
        self.upcomingCollectionView.register(UINib(nibName: "UpComingEventsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "upcomingCell")
        setUpUpcomingCollectionViewSize()
        
        leagueDetailsPresenter!.getLatestEvents()
        self.latestCollectionView.register(UINib(nibName: "LatestEventsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "latestCell")
        setupLatestCollectionViewSize()
        
        if (leagueDetailsPresenter?.isFavouite(leagueId: league?.id ?? ""))!{
            favouriteButton.setImage(favImage, for: .normal)
        }else{
            favouriteButton.setImage(notFavImage, for: .normal)
        }
        
        let swipeLeft = UISwipeGestureRecognizer()
        swipeLeft.addTarget(self, action: #selector(backSegue) )
        swipeLeft.direction = .left
        self.view!.addGestureRecognizer(swipeLeft)
        
        leagueDetailsPresenter!.getAllTeams(query: (league?.name)!)
        self.teamsCollectionView.register(UINib(nibName: "TeamsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "teamsCell")
            calculateTheTeamsCellSize()
    }
    
    @IBAction func favouriteAction(_ sender: UIButton) {
        if favouriteButton.currentImage == favImage{
            leagueDetailsPresenter?.deleteFromFavourite(leagueId: (league?.id) ?? "")
            favouriteButton.setImage(notFavImage, for: .normal)
            
        }else{
            leagueDetailsPresenter?.saveLeagueToDatabase(league: league!)
            favouriteButton.setImage(favImage, for: .normal)
        }
    }
    
    @IBAction func backSegue() {
        performSegue(withIdentifier: "unWindToLeagues", sender: self)
    }
}