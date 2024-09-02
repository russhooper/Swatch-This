//
//  GKTurnBasedMatch+Additions.swift
//  Swatch This
//
//  Created by Russ Hooper on 7/26/20.
//  Copyright © 2020 Radio Silence. All rights reserved.
//

import GameKit

extension GKTurnBasedMatch {
  var isLocalPlayersTurn: Bool {
    return currentParticipant?.player == GKLocalPlayer.local
  }
  
  var others: [GKTurnBasedParticipant] {
    return participants.filter {
      return $0.player != GKLocalPlayer.local
    }
  }
}
