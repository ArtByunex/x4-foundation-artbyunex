<?xml version="1.0" encoding="utf-8"?>
<mdscript name="GS_Boron2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="md.xsd">
  <cues>
    <cue name="Start" namespace="this" module="x4ep1_gamestart_boron2">
      <conditions>
        <event_cue_completed cue="md.Setup_Gamestarts.X4ep1_Gamestart_Boron_Shared" />
      </conditions>
      <actions>
        <set_value name="$debugchance" exact="0" comment="keep ai-scripts from complaining"/>
        <set_value name="$DebugChance" exact="100"/>
        <set_value name="$MissionCue"  exact="this"/>
        <set_value name="$Page"        exact="30291"/>

        <set_value name="$MissionActors" exact="table[]"/>
      </actions>
      <cues>
        <cue name="Setup">
          <actions>
            <!--Find and setup HQ-->
            <find_sector name="$HQSector" macro="macro.cluster_31_sector001_macro" comment="Heretic's End" required="true"/>
            <find_station name="$HQ" space="$HQSector" godstationentry="'gs_boron2_hq'" multiple="false" required="true"/>
            <do_if value="$HQ">
              <signal_cue_instantly cue="md.X4Ep1_Mentor_Subscriptions.Other_Story_HQ_Handover" param="table[$hq = $HQ, $initialise = false, $addboso = true]"/>
              <set_value name="md.X4Ep1_Mentor_Subscriptions.Start.$SuppressFirstMeeting" exact="true"/>
              <run_actions ref="md.LIB_Generic.RequestObjectInvincibility">
                <param name="Object"        value="$HQ"/>
                <param name="RequesterCue"  value="md.Story_Boron.Start"/>
                <param name="DebugChance"   value="$DebugChance"/>
              </run_actions>
            </do_if>
          </actions>
          <cues>

            <cue name="Setup_Complete">
              <conditions>
                <check_any comment="listen to all setup cues to know when all is done">
                  <event_cue_completed cue="Setup_QueenShip"/>
                  <event_cue_completed cue="Setup_QueenShip_ThroneRoom"/>
                  <event_cue_completed cue="Setup_QueenShip_BriefingRoom"/>
                  <event_cue_completed cue="Setup_Actors"/>
                  <event_cue_completed cue="Setup_PlayerPosition"/>
                  <event_cue_completed cue="Setup_Map"/>
                </check_any>
                <cue_is_complete cue="Setup_QueenShip"/>
                <cue_is_complete cue="Setup_QueenShip_ThroneRoom"/>
                <cue_is_complete cue="Setup_QueenShip_BriefingRoom"/>
                <cue_is_complete cue="Setup_Actors"/>
                <cue_is_complete cue="Setup_PlayerPosition"/>
                <cue_is_complete cue="Setup_Map"/>
              </conditions>
              <actions>
                <signal_cue cue="Ch1_HeraldGathering"/>
              </actions>
            </cue>
            <cue name="Setup_Signals" comment="check_values in the signalled cues">
              <actions>
                <!-- signal cues in case they are completed before we listen to event_cue_completed -->
                <signal_cue_instantly check="false" cue="Setup_QueenShip"/>
                <signal_cue_instantly check="false" cue="Setup_QueenShip_ThroneRoom"/>
                <signal_cue_instantly check="false" cue="Setup_QueenShip_BriefingRoom"/>
                <signal_cue_instantly check="false" cue="Setup_Actors"/>
                <signal_cue_instantly check="false" cue="Setup_PlayerPosition_LeaveControlPosition"/>
                <signal_cue_instantly check="false" cue="Setup_BosoTa"/>
              </actions>
            </cue>

            <!-- Create Ship -->
            <cue name="Setup_QueenShip">
              <conditions>
                <check_any>
                  <event_cue_signalled/>
                  <event_cue_completed cue="md.Story_Boron.Setup"/>
                </check_any>
                <cue_is_complete cue="md.Story_Boron.Setup"/>
              </conditions>
              <actions>
                <signal_cue_instantly cue="md.Story_Boron.Setup_KingdomEnd_QueenFleet"/>
                <set_value name="$BoronQueenTransportShip" exact="md.Story_Boron.Start.$BoronQueenTransportShip"/>
                <assert value="$BoronQueenTransportShip.exists" text="'[Heinrich] Queen ship missing.'"/>
              </actions>
            </cue>
            <cue name="Setup_QueenShip_ThroneRoom">
              <conditions>
                <check_any>
                  <event_cue_signalled/>
                  <event_cue_completed cue="md.Story_Boron.Setup_KingdomEnd_QueenFleet_Throneroom"/>
                </check_any>
                <cue_is_complete cue="md.Story_Boron.Setup_KingdomEnd_QueenFleet_Throneroom"/>
              </conditions>
              <actions>
                <set_value name="$ThroneRoom" exact="md.Story_Boron.Start.$ThroneRoom"/>
              </actions>
            </cue>
            <cue name="Setup_QueenShip_BriefingRoom">
              <conditions>
                <check_any>
                  <event_cue_signalled/>
                  <event_cue_completed cue="md.Story_Boron.Setup_KingdomEnd_QueenFleet_BriefingRoom"/>
                </check_any>
                <cue_is_complete cue="md.Story_Boron.Setup_KingdomEnd_QueenFleet_BriefingRoom"/>
              </conditions>
              <actions>
                <set_value name="$QSBriefingRoom" exact="md.Story_Boron.Start.$QSBriefingRoom"/>
              </actions>
            </cue>

            <!-- BosoTo (delayed, we don't wait for this) -->
            <cue name="Setup_BosoTa" instantiate="true">
              <conditions>
                <check_any>
                  <event_cue_signalled/>
                  <event_cue_completed cue="md.X4Ep1_Mentor_Subscriptions.UnlockResearch"/>
                  <event_cue_completed cue="md.X4Ep1_Mentor_Subscriptions.Phase_Boron_Boso_JumpedIntoHE_Introductions"/>
                </check_any>
              </conditions>
              <actions>
                <set_value name="$BosoTa" exact="md.$PersistentCharacters.$BosoTa"/>
                <assert value="$BosoTa != null" text="'Boso is null'"/>
                <set_entity_traits entity="$BosoTa" customhandler="true"/>
                <set_value name="$MissionActors.$BosoTa" exact="table[
                                              $entity = $BosoTa,
                                              $monitor = table[
                                                $cutscenekey = 'ShowCharacterBoron',
                                                $forceonplayer = true,
                                                $ignoredistance = true
                                              ]
                                            ]"/>
              </actions>
            </cue>

            <!-- Place Actors on Ship -->
            <cue name="Setup_Actors">
              <conditions>
                <check_any>
                  <event_cue_signalled/>
                  <event_cue_completed cue="Setup_QueenShip"/>
                  <event_cue_completed cue="Setup_QueenShip_ThroneRoom"/>
                  <event_cue_completed cue="Setup_QueenShip_BriefingRoom"/>
                  <event_cue_completed cue="md.Story_Boron.Setup_KingdomEnd_QueenFleet_Place_Queen"/>
                  <event_cue_completed cue="md.Story_Boron.Setup_CharacterBoronQueen"/>
                  <event_cue_completed cue="md.Story_Boron.Setup_Character_AllianceLeader"/>
                  <event_cue_completed cue="md.Story_Boron.Setup_CharactersBoronHerald"/>
                  <event_cue_completed cue="md.Story_Boron.Setup_CharactersBoronHerald2"/>
                  <event_cue_completed cue="md.Story_Boron.Setup_CharactersBoronAnnouncer"/>
                </check_any>
                <cue_is_complete cue="Setup_QueenShip"/>
                <cue_is_complete cue="Setup_QueenShip_ThroneRoom"/>
                <cue_is_complete cue="Setup_QueenShip_BriefingRoom"/>
                <cue_is_complete cue="md.Story_Boron.Setup_KingdomEnd_QueenFleet_Place_Queen"/>
                <cue_is_complete cue="md.Story_Boron.Setup_CharacterBoronQueen"/>
                <cue_is_complete cue="md.Story_Boron.Setup_Character_AllianceLeader"/>
                <cue_is_complete cue="md.Story_Boron.Setup_CharactersBoronHerald"/>
                <cue_is_complete cue="md.Story_Boron.Setup_CharactersBoronHerald2"/>
                <cue_is_complete cue="md.Story_Boron.Setup_CharactersBoronAnnouncer"/>
              </conditions>
              <actions>                
                <!-- Set Variables -->
                <set_value name="$BoronQueenActor"        exact="md.Story_Boron.Start.$BoronQueenActor"/>
                <set_value name="$ExpeditionLeaderActor"  exact="md.Story_Boron.Start.$ExpeditionLeaderActor"/>
                <set_value name="$BoronHeraldActor"       exact="md.Story_Boron.Start.$BoronHeraldActor"/>
                <set_value name="$BoronHerald2Actor"      exact="md.Story_Boron.Start.$BoronHerald2Actor"/>
                <set_value name="$BoronAnnouncerActor"    exact="md.Story_Boron.Start.$BoronAnnouncerActor"/>

                <!-- Setup MissionActors for Usecases-->
                <set_value name="$MissionActors.$BoronQueenActor" exact="table[
                                              $entity = $BoronQueenActor,
                                              $monitor = table[
                                                $cutscenekey = 'ShowNPCFace',
                                                $forceonplayer = true,
                                                $ignoredistance = true,
                                                $caption = true
                                              ]
                                            ]"/>
                <set_value name="$MissionActors.$ExpeditionLeaderActor" exact="table[
                                              $entity = $ExpeditionLeaderActor,
                                              $monitor = table[
                                                $cutscenekey = 'ShowNPCFace',
                                                $forceonplayer = true,
                                                $ignoredistance = true,
                                                $caption = true
                                              ]
                                            ]"/>
                <set_value name="$MissionActors.$BoronHeraldActor" exact="table[
                                              $entity = $BoronHeraldActor,
                                              $monitor = table[
                                                $cutscenekey = 'ShowNPCFace',
                                                $forceonplayer = true,
                                                $ignoredistance = true,
                                                $caption = true
                                              ]
                                            ]"/>
                <set_value name="$MissionActors.$BoronHerald2Actor" exact="table[
                                              $entity = $BoronHerald2Actor,
                                              $monitor = table[
                                                $cutscenekey = 'ShowNPCFace',
                                                $forceonplayer = true,
                                                $ignoredistance = true,
                                                $caption = true
                                              ]
                                            ]"/>
                <set_value name="$MissionActors.$BoronAnnouncerActor" exact="table[
                                              $entity = $BoronAnnouncerActor,
                                              $monitor = table[
                                                $cutscenekey = 'ShowNPCFace',
                                                $forceonplayer = true,
                                                $ignoredistance = true,
                                                $caption = true
                                              ]
                                            ]"/>
              </actions>
              <cues>
                <cue name="Setup_Actors_Placement_Initial">
                  <actions>
                    <signal_cue cue="md.Story_Boron.Setup_QueenFleet_Throneroom_Place_ExpeditionLeader"/>
                    <signal_cue cue="md.Story_Boron.Setup_KingdomEnd_QueenFleet_BriefingRoom_Place_Heralds"/>
                  </actions>
                </cue>

                <cue name="Setup_Actors_Placement_ThroneRoom">
                  <conditions>
                    <event_cue_signalled/>
                  </conditions>
                  <delay exact="0.8s" comment="looks odd if they move exactly when the player gets an objective"/>
                  <actions>
                    <do_if value="Setup_Actors_Placement_ThroneRoom_Player.state == cuestate.waiting">
                      <signal_cue_instantly cue="md.Story_Boron.Setup_QueenFleet_Throneroom_Place_Heralds" param="0.6s"/>
                    </do_if>
                  </actions>
                </cue>
                <cue name="Setup_Actors_Placement_ThroneRoom_Player">
                  <conditions>
                    <event_cue_signalled/>
                  </conditions>
                  <actions>
                    <fade_screen fadeout="1s" fadein="2s" realtime="true"/>
                    <signal_cue_instantly cue="md.Story_Boron.Setup_QueenFleet_Throneroom_Force_Heralds"/>
                    <play_music music="'music_boron_throneroom_cutscene'"/>
                  </actions>
                  <delay exact="1s"/>
                  <actions>
                    <add_actor_to_room actor="player.entity" object="$ThroneRoom" comment="player.controlled needs to be false">
                      <position value="position.[2.970479m, -0.421948m, -5.760302m]"/>
                      <rotation yaw="-180.0deg"/>
                    </add_actor_to_room>
                  </actions>
                </cue>

              </cues>
            </cue>

            <!-- Place Player on Ship -->
            <cue name="Setup_PlayerPosition_LeaveControlPosition">
              <conditions>
                <check_any>
                  <event_cue_signalled/>
                  <event_cue_completed cue="Setup_QueenShip_ThroneRoom"/>
                  <event_cue_completed cue="Setup_QueenShip_BriefingRoom"/>
                </check_any>
                <cue_is_complete cue="Setup_QueenShip_ThroneRoom"/>
                <cue_is_complete cue="Setup_QueenShip_BriefingRoom"/>
              </conditions>
              <actions>
                <do_if value="player.controlled">
                  <leave_control_position/>
                </do_if>
                <do_else>
                  <signal_cue cue="Setup_PlayerPosition"/>
                </do_else>
              </actions>
            </cue>
            <cue name="Setup_PlayerPosition">
              <conditions>
                <check_any>
                  <event_cue_signalled/>
                  <event_player_stopped_control/>
                </check_any>
              </conditions>
              <actions>
                <add_actor_to_room actor="player.entity" object="$QSBriefingRoom" comment="player.controlled needs to be false">
                  <position x="-1.837" y="1.713" z="-7.532"/>
                  <rotation yaw="170.0deg"/>
                </add_actor_to_room>
              </actions>
            </cue>

            <cue name="Setup_Map">
              <actions>
                <!-- Open Boron Gates -->
                <signal_cue_instantly cue="md.Setup_DLC_Boron.Boron_Gates_Open_KingdomEnd"/>

                <!-- 11 Boron DLC Sectors -->
                <!-- Provinces Adrift -->
                <find_sector macro="macro.cluster_601_sector001_macro" space="player.galaxy" extension="'ego_dlc_boron'" required="true" name="$WatchfulGazeSector"/>
                <find_sector macro="macro.cluster_602_sector001_macro" space="player.galaxy" extension="'ego_dlc_boron'" required="true" name="$BarrenShoresSector"/>
                <find_sector macro="macro.cluster_603_sector001_macro" space="player.galaxy" extension="'ego_dlc_boron'" required="true" name="$GreatReefSector"/>
                <find_sector macro="macro.cluster_604_sector001_macro" space="player.galaxy" extension="'ego_dlc_boron'" required="true" name="$OceanOfFantasySector"/>
                <find_sector macro="macro.cluster_605_sector001_macro" space="player.galaxy" extension="'ego_dlc_boron'" required="true" name="$SoDSector"/>
                <!-- Queendom Space -->
                <find_sector macro="macro.cluster_606_sector001_macro" space="player.galaxy" extension="'ego_dlc_boron'" required="true" name="$KingdomEndISector"/>
                <find_sector macro="macro.cluster_606_sector002_macro" space="player.galaxy" extension="'ego_dlc_boron'" required="true" name="$ReflectingStarsSector"/>
                <find_sector macro="macro.cluster_606_sector003_macro" space="player.galaxy" extension="'ego_dlc_boron'" required="true" name="$ToweringWaveSector"/>
                <find_sector macro="macro.cluster_607_sector001_macro" space="player.galaxy" extension="'ego_dlc_boron'" required="true" name="$RolksDemiseSector"/>
                <find_sector macro="macro.cluster_608_sector001_macro" space="player.galaxy" extension="'ego_dlc_boron'" required="true" name="$AtreusCloudSector"/>
                <find_sector macro="macro.cluster_609_sector001_macro" space="player.galaxy" extension="'ego_dlc_boron'" required="true" name="$MenelausOasisSector"/>

                <!-- We're a Queendom character and know Queendom space only, but kindly got information about all Boron sectors from our Provinces Adrift friends or something for player convenience -->
                <set_value name="$InitialMap" exact="[
                    macro.cluster_606_sector001_macro,
                    macro.cluster_606_sector002_macro,
                    macro.cluster_606_sector003_macro,
                    macro.cluster_607_sector001_macro,
                    macro.cluster_608_sector001_macro,
                    macro.cluster_609_sector001_macro,
                    macro.cluster_601_sector001_macro,
                    macro.cluster_602_sector001_macro,
                    macro.cluster_603_sector001_macro,
                    macro.cluster_604_sector001_macro,
                    macro.cluster_605_sector001_macro
                  ]"/>
                <run_actions ref="md.LIB_Generic.UncoverMap_SectorsAndGates" >
                  <param name="InitialMap" value="$InitialMap"/>
                  <param name="UncoverStationFaction"     value="faction.boron"/>
                  <param name="UncoverShipyardsAndWharfs" value="true" comment="optional"/>
                  <param name="UncoverTradeStations"      value="true" comment="optional"/>
                  <param name="UncoverHighways"           value="true"/>
                </run_actions>
              </actions>
            </cue>
          </cues>
        </cue>

        <cue name="Idle_Lines">
          <conditions>
            <event_cue_completed cue="Setup_Actors"/>
          </conditions>
          <cues>
            <cue name="Idle_Queen" instantiate="true">
              <conditions>
                <event_conversation_started actor="$BoronQueenActor"/>
                <check_value value="$ThroneSpeech_Done?"/>
                <cue_is_waiting cue="md.Story_Boron.Ch6_Tasks" comment="story takes over idle line handling"/>
              </conditions>
              <actions>
                <allow_conversation_escape enabled="false"/>
                <add_npc_line speaker="$BoronQueenActor" hidechoices="true">
                  <text line="30291040" comment="readtext.{10253}.{30291040} (QuickLookup)"/>
                </add_npc_line>
              </actions>
            </cue>
            <cue name="Idle_Heralds" instantiate="true">
              <conditions>
                <check_any>
                  <event_conversation_started actor="$BoronHeraldActor"/>
                  <event_conversation_started actor="$BoronHerald2Actor"/>
                </check_any>
                <cue_is_waiting cue="md.Story_Boron.Ch6_Tasks" comment="story takes over idle line handling"/>
              </conditions>
              <actions>
                <do_if value="$Ch1Heralds_Done? and (cuestate.waiting == Ch2_Throneroom.state)">
                  <add_npc_line speaker="event.object" hidechoices="true">
                    <text line="30291001" comment="readtext.{10205}.{30291001} readtext.{10257}.{30291001}(QuickLookup)"/>
                  </add_npc_line>
                </do_if>
                <do_elseif value="$Ch1Heralds_Done? and (not $ThroneSpeech_Done?)">
                  <add_npc_line speaker="event.object" hidechoices="true">
                    <text line="30291006" comment="readtext.{10205}.{30291006} readtext.{10257}.{30291006}(QuickLookup)"/>
                  </add_npc_line>
                </do_elseif>
                <do_elseif value="$Ch1Heralds_Done? and $ThroneSpeech_Done?">
                  <add_npc_line speaker="event.object" hidechoices="true">
                    <text line="30291040" comment="readtext.{10205}.{30291040} readtext.{10257}.{30291040}(QuickLookup)"/>
                  </add_npc_line>
                </do_elseif>
              </actions>
            </cue>
            <cue name="Idle_Announcer" instantiate="true">
              <conditions>
                <event_conversation_started actor="$BoronAnnouncerActor"/>
                <cue_is_waiting cue="md.Story_Boron.Ch6_Tasks" comment="story takes over idle line handling"/>
              </conditions>
              <actions>
                <do_if value="$ThroneSpeech_Done?">
                  <add_npc_line speaker="$BoronAnnouncerActor" hidechoices="true">
                    <text line="30291021" comment="readtext.{10255}.{30291021} (QuickLookup)"/>
                  </add_npc_line>
                </do_if>
              </actions>
            </cue>
          </cues>
        </cue>

        <cue name="Ch1_HeraldGathering">
          <conditions>
            <event_cue_signalled/>
          </conditions>
          <actions>
            <debug_text text="'Starting Boron gamestart 2'" chance="$DebugChance"/>
          </actions>
          <cues>

            <cue name="Precache_HeraldActors">
              <actions>
                <precache_hint target="$BoronHeraldActor"/>
                <precache_hint target="$BoronHerald2Actor"/>
              </actions>
            </cue>

            <cue name="Ch1_Dialog">
              <cues>
                <cue name="Ch1_Initial_Dialog" instantiate="true">
                  <conditions>
                    <check_any>
                      <event_conversation_started actor="$BoronHeraldActor"/>
                      <event_conversation_started actor="$BoronHerald2Actor"/>
                    </check_any>
                    <check_value value="not $Ch1Heralds_Done?"/>
                  </conditions>
                  <actions>
                    <add_npc_line speaker="$BoronHeraldActor" hidechoices="true" recipient="$BoronHerald2Actor" lookat="$BoronHerald2Actor">
                      <text line="30291001" comment="readtext.{10205}.{30291001} (QuickLookup)"/>
                    </add_npc_line>
                    <add_npc_line speaker="$BoronHerald2Actor" hidechoices="true" recipient="$BoronHeraldActor" lookat="$BoronHeraldActor">
                      <text line="30291001" comment="readtext.{10257}.{30291001} (QuickLookup)"/>
                      <text line="30291002" comment="readtext.{10257}.{30291002} (QuickLookup)"/>
                    </add_npc_line>
                    <add_npc_line speaker="$BoronHeraldActor" hidechoices="true" recipient="$BoronHerald2Actor" lookat="$BoronHerald2Actor">
                      <text line="30291002" comment="readtext.{10205}.{30291002} (QuickLookup)"/>
                      <text line="30291003" comment="readtext.{10205}.{30291003} (QuickLookup)"/>
                    </add_npc_line>
                    <add_npc_line speaker="$BoronHerald2Actor" hidechoices="true" recipient="$BoronHeraldActor" lookat="$BoronHeraldActor">
                      <text line="30291003" comment="readtext.{10257}.{30291003} (QuickLookup)"/>
                      <text line="30291004" comment="readtext.{10257}.{30291004} (QuickLookup)"/>
                    </add_npc_line>
                    <add_npc_line speaker="$BoronHeraldActor" hidechoices="true" recipient="$BoronHerald2Actor" lookat="$BoronHerald2Actor">
                      <text line="30291004" comment="readtext.{10205}.{30291004} (QuickLookup)"/>
                    </add_npc_line>
                    <add_npc_line speaker="$BoronHerald2Actor" hidechoices="true" recipient="$BoronHeraldActor" lookat="$BoronHeraldActor">
                      <text line="30291005" comment="readtext.{10257}.{30291005} (QuickLookup)"/>
                    </add_npc_line>
                    <add_npc_line speaker="$BoronHeraldActor" hidechoices="true" recipient="$BoronHerald2Actor" lookat="$BoronHerald2Actor">
                      <text line="30291005" comment="readtext.{10205}.{30291005} (QuickLookup)"/>
                    </add_npc_line>
                  </actions>
                </cue>

                <cue name="Ch1_Initial_Dialog_Done">
                  <conditions>
                    <check_any>
                      <event_speak_finished      actor="$BoronHeraldActor"  line="30291005"/>
                      <event_speak_finished      actor="$BoronHerald2Actor" line="30291005"/>
                      <event_speak_line_finished actor="$BoronHeraldActor"  line="30253492"/>
                      <event_speak_line_finished actor="$BoronHerald2Actor" line="30253492"/>
                      <check_all>
                        <event_object_changed_room object="player.entity"/>
                        <check_value value="event.param != $QSBriefingRoom"/>
                      </check_all>
                    </check_any>
                  </conditions>
                  <actions>
                    <set_value name="$Ch1Heralds_Done"/>
                    <signal_cue cue="Ch1_Announcement"/>
                  </actions>
                </cue>
              </cues>
            </cue>

            <cue name="Ch1_Announcement">
              <conditions>
                <event_cue_signalled/>
              </conditions>
              <delay exact="3s"/>
              <actions>
                <cancel_cue cue="Ch1_HeraldGathering"/>
                <signal_cue_instantly cue="md.NPC_UseCases.UseCase" param="table[
                              $caller = this, $preset = '$plot', $actors = $MissionActors, $debugchance = 0, $missioncue = $MissionCue,
                              $script = [
                                table[ $actor = '$BoronAnnouncerActor', $speak = 30291001, $broadcast = true, $monitor = false],
                                table[ $actor = '$BoronAnnouncerActor', $speak = 30291002, $broadcast = true, $monitor = false],
                                table[ $actor = '$BoronAnnouncerActor', $speak = 30291003, $broadcast = true, $monitor = false]
                              ],
                              $callbackcue = Ch2_Throneroom,
                              $abortcallbackcue = Ch2_Throneroom
                            ]" />
              </actions>
            </cue>

          </cues>
        </cue>

        <cue name="Ch2_Throneroom">
          <conditions>
            <event_cue_signalled/>
          </conditions>
          <actions>
            <signal_cue cue="Setup_Actors_Placement_ThroneRoom"/>
          </actions>
          <cues>

            <!-- Mission -->
            <cue name="Ch2_Mission" version="2">
              <actions>
                <create_mission cue="$MissionCue" activate="true"
                                name="{30291,1001}" description="{30291,1003}" rewardtext="{30291,1002}"
                                type="missiontype.plot" faction="faction.boron" difficulty="level.trivial" abortable="false" icon="'briefing_polypheides_01'" iconcaption="$BoronQueenActor.knownname" group="missiongroup.gs_boron2">
                  <briefing>
                    <objective step="1" action="objective.goto" object="$ThroneRoom"/>
                  </briefing>
                </create_mission>
                <set_value name="$MissionStep" exact="1"/>
                <set_objective_from_briefing cue="$MissionCue" step="$MissionStep"/>
              </actions>
              <patch sinceversion="2">
                <do_if value="$MissionCue.hasmission">
                  <update_mission_thread cue="$MissionCue" group="missiongroup.gs_boron2"/>
                </do_if>
              </patch>
            </cue>

            <!-- Ch2_1 Throneroom Scene -->
            <cue name="Ch2_1_Throneroom_Speech_Check" onfail="cancel">
              <conditions>
                <check_value value="player.entity.room == $ThroneRoom"/>
              </conditions>
              <actions>
                <signal_cue_instantly cue="Ch2_1_Throneroom_Speech"/>
              </actions>
            </cue>
            <cue name="Ch2_1_Throneroom_Speech">
              <conditions>
                <check_any>
                  <event_object_changed_room object="player.entity" room="$ThroneRoom"/>
                  <event_cue_signalled/>
                </check_any>
              </conditions>
              <actions>
                <signal_cue_instantly cue="Setup_Actors_Placement_ThroneRoom_Player"/>
              </actions>
              <delay exact="1s"/>
              <actions>
                <set_value name="$MissionStep" operation="add"/>
                <set_objective cue="$MissionCue" action="objective.observe" text="{30291,1320}" comment="Observe: Royal Ceremony" step="$MissionStep" updatebriefing="true"/>
              </actions>
              <cues>
                <!-- Queen Speech -->
                <cue name="Cutscene">
                  <conditions>
                    <event_cue_signalled/>
                  </conditions>
                  <actions>
                    <set_value name="this.$CutsceneKey" exact="'Story_Boron_Ch5_Queen_Briefing'"/>
                    <play_cutscene result="this.$CutsceneID" key="this.$CutsceneKey" abortable="true">
                      <param name="target_queen"      object="$BoronQueenActor"/>
                      <param name="target_ALILeader"  object="$ExpeditionLeaderActor"/>
                      <param name="target_nila"       object="$BoronHeraldActor"/>
                      <param name="target_boso"       object="$BoronAnnouncerActor"/>
                    </play_cutscene>
                    <set_value name="$CurrentShot" exact="1"/>

                    <set_value name="$Cutsene_Shot_Start" exact="
                                   [ 'TriggerSequence1Start',
                                     'TriggerSequence2Start',
                                     'TriggerSequence3Start',
                                     'TriggerSequence4Start',
                                     'TriggerSequence5Start',
                                     'TriggerSequence6Start',
                                     'TriggerSequence7Start'
                                   ]"/>

                    <set_value name="$Cutsene_Shot_Done" exact="
                                   [ 'TriggerSequence1Done',
                                     'TriggerSequence2Done',
                                     'TriggerSequence3Done',
                                     'TriggerSequence4Done',
                                     'TriggerSequence5Done',
                                     'TriggerSequence6Done',
                                     'TriggerSequence7Done'
                                   ]"/>
                  </actions>
                  <cues>

                    <cue name="Cutscene_Precache" instantiate="true">
                      <conditions>
                        <event_cue_signalled/>
                      </conditions>
                      <actions>
                        <precache_hint target="$ThroneRoom"/>
                        <do_for_each in="$MissionActors" name="$actor" valuename="$actorTable">
                          <precache_hint target="$actorTable.$entity"/>
                        </do_for_each>
                        <precache_hint target="player.entity"/>
                      </actions>
                    </cue>

                    <cue name="Cutscene_Shot_Start" instantiate="true">
                      <conditions>
                        <event_cue_signalled/>
                        <cue_is_waiting cue="Cutscene_End"/>
                      </conditions>
                      <actions>
                        <signal_cue_instantly cue="Cutscene_Precache"/>
                        <signal_cue_instantly cue="Cutscene_Shot_Done" param="$CurrentShot"/>
                        <set_value name="$CurrentShot" exact="event.param"/>
                        <cutscene_event key="parent.$CutsceneKey" event="$Cutsene_Shot_Start.{$CurrentShot}"/>
                      </actions>
                    </cue>

                    <cue name="Cutscene_Shot_Done" instantiate="true">
                      <conditions>
                        <event_cue_signalled/>
                        <cue_is_waiting cue="Cutscene_End"/>
                      </conditions>
                      <actions>
                        <cutscene_event key="parent.$CutsceneKey" event="$Cutsene_Shot_Done.{event.param}"/>
                      </actions>
                    </cue>

                    <cue name="Cutscene_End">
                      <conditions>
                        <event_cue_signalled/>
                      </conditions>
                      <actions>
                        <signal_cue_instantly cue="Cutscene_Shot_Done" param="$CurrentShot"/>
                        <stop_cutscene cutscene="parent.$CutsceneID"/>
                        <signal_cue cue="Ch1_Queen_IntroDone" check="false"/>
                      </actions>
                    </cue>

                    <cue name="Cutscene_Ended">
                      <conditions>
                        <event_cutscene_stopped cutscene="parent.$CutsceneID"/>
                      </conditions>
                      <actions>
                        <do_if value="event.param3">
                          <signal_cue cue="Cutscene_Interrupted"/>
                        </do_if>
                      </actions>
                      <delay exact="0.5s"/>
                      <actions>
                        <signal_cue cue="Ch1_Queen_IntroDone" check="false"/>
                      </actions>
                    </cue>

                    <cue name="Cutscene_Interrupted">
                      <conditions>
                        <event_cue_signalled/>
                      </conditions>
                    </cue>

                  </cues>
                </cue>
                
                <cue name="Ch2_Queen_Speech">
                  <cues>
                    <cue name="Ch2_Queen_Speech_StartConversation">
                      <conditions>
                        <event_cue_completed cue="Setup_Actors_Placement_ThroneRoom_Player"/>
                        <check_value value="not $ThroneSpeech_Done?"/>
                      </conditions>
                      <actions>
                        <signal_cue_instantly cue="Cutscene"/>
                        <!--    Cutscenes
                                Shot2 - Queen Portrait, but looking over ALI shoulder
                                Shot3 - ALI Leader Portrait, camera from entry?
                                Shot4 - Queen Closeup
                                Shot5 - Herald Portrait
                                Shot6 - Queen Full Body, but also the empty spot to her left
                                Shot7 - Announcer Portrait -->
                        <signal_cue_instantly cue="md.NPC_UseCases.UseCase"
                                              param="table[ $caller = this,
                                                            $preset = '$plot', $missioncue = $MissionCue,
                                                            $actors = $MissionActors,
                                                            $debugchance = 0,
                                                            $abortonsignalledcue = Cutscene_Interrupted,
                                                            $callbackcue = Cutscene_End,
                                                            $abortcallbackcue = Cutscene_End,
                                                            $script = [
                                              3.5s,
                                              table[ $actor = '$BoronAnnouncerActor', $speak = 30291010, $recipient = 'player', $comment = 'readtext.{10255}.{30291010} (QuickLookup)'],
                                              table[ $actor = '$BoronAnnouncerActor', $speak = 30291011, $recipient = 'player', $comment = 'readtext.{10255}.{30291011} (QuickLookup)'],
                                              table[ $actor = '$BoronAnnouncerActor', $speak = 30291012, $recipient = 'player', $comment = 'readtext.{10255}.{30291012} (QuickLookup)'],
                                              table[ $select = [
                                                      table[$weight = (if (player.name == readtext.{1021}.{1502}) then 100 else 0), $actor = '$BoronAnnouncerActor', $speak = 30291013, $recipient = 'player', $comment = 'readtext.{10255}.{30291013} (QuickLookup)', $speakcallbackcue = Cutscene_Precache],
                                                      table[$weight = (if (player.name != readtext.{1021}.{1502}) then 100 else 0), $actor = '$BoronAnnouncerActor', $speak = 30291014, $recipient = 'player', $comment = 'readtext.{10255}.{30291014} (QuickLookup)', $speakcallbackcue = Cutscene_Precache]
                                                    ]],
                                              table[ $actor = '$BoronAnnouncerActor', $speak = 30291015, $recipient = 'player', $comment = 'readtext.{10255}.{30291015} (QuickLookup)', $speakcallbackcue = Cutscene_Shot_Start, $speakcallbackparam = 2 ],
                                              0.5s,
                                              
                                              table[ $actor = '$BoronQueenActor', $speak = 30291010, $recipient = 'player', $comment = 'readtext.{10253}.{30291010} (QuickLookup)'],
                                              table[ $actor = '$BoronQueenActor', $speak = 30291011, $recipient = 'player', $comment = 'readtext.{10253}.{30291011} (QuickLookup)', $speakcallbackcue = Cutscene_Precache],
                                              table[ $actor = '$BoronQueenActor', $speak = 30291012, $recipient = 'player', $comment = 'readtext.{10253}.{30291012} (QuickLookup)', $speakcallbackcue = Cutscene_Shot_Start, $speakcallbackparam = 3 ],
                                              0.5s,
                                              
                                              table[ $actor = '$ExpeditionLeaderActor', $speak = 30291010, $recipient = 'player', $comment = 'readtext.{10359}.{30291010} (QuickLookup)', $speakcallbackcue = Cutscene_Shot_Start, $speakcallbackparam = 4 ],
                                              0.5s,

                                              table[ $actor = '$BoronQueenActor', $speak = 30291020, $recipient = 'player', $comment = 'readtext.{10253}.{30291020} (QuickLookup)'],
                                              table[ $actor = '$BoronQueenActor', $speak = 30291021, $recipient = 'player', $comment = 'readtext.{10253}.{30291021} (QuickLookup)'],
                                              table[ $actor = '$BoronQueenActor', $speak = 30291022, $recipient = 'player', $comment = 'readtext.{10253}.{30291022} (QuickLookup)'],
                                              table[ $actor = '$BoronQueenActor', $speak = 30291023, $recipient = 'player', $comment = 'readtext.{10253}.{30291023} (QuickLookup)'],
                                              table[ $actor = '$BoronQueenActor', $speak = 30291024, $recipient = 'player', $comment = 'readtext.{10253}.{30291024} (QuickLookup)'],
                                              table[ $actor = '$BoronQueenActor', $speak = 30291025, $recipient = 'player', $comment = 'readtext.{10253}.{30291025} (QuickLookup)'],
                                              table[ $actor = '$BoronQueenActor', $speak = 30291026, $recipient = 'player', $comment = 'readtext.{10253}.{30291026} (QuickLookup)'],
                                              table[ $actor = '$BoronQueenActor', $speak = 30291031, $recipient = 'player', $comment = 'readtext.{10253}.{30291031} (QuickLookup)'],
                                              table[ $actor = '$BoronQueenActor', $speak = 30291027, $recipient = 'player', $comment = 'readtext.{10253}.{30291027} (QuickLookup)'],
                                              table[ $actor = '$BoronQueenActor', $speak = 30291028, $recipient = 'player', $comment = 'readtext.{10253}.{30291028} (QuickLookup)'],
                                              table[ $actor = '$BoronQueenActor', $speak = 30291029, $recipient = 'player', $comment = 'readtext.{10253}.{30291029} (QuickLookup)', $speakcallbackcue = Cutscene_Precache],
                                              table[ $actor = '$BoronQueenActor', $speak = 30291030, $recipient = 'player', $comment = 'readtext.{10253}.{30291030} (QuickLookup)', $speakcallbackcue = Cutscene_Shot_Start, $speakcallbackparam = 7 ],
                                              0.65s,

                                              table[ $actor = '$BoronAnnouncerActor', $speak = 30291020, $recipient = 'player', $comment = 'readtext.{10255}.{30291020} (QuickLookup)'],
                                              table[ $actor = '$BoronAnnouncerActor', $speak = 30291021, $recipient = 'player', $comment = 'readtext.{10255}.{30291021} (QuickLookup)'],
                                              table[ $actor = '$BoronAnnouncerActor', $speak = 30291022, $recipient = 'player', $comment = 'readtext.{10255}.{30291022} (QuickLookup)'],

                                              ]
                                                                                ]" />
                      </actions>
                    </cue>

                    <cue name="Ch2_Queen_Speech_Conver" comment="deprecated, prevent new cues with the same name"/>

                    <cue name="Ch1_Queen_IntroDone">
                      <conditions>
                        <event_cue_signalled/>
                      </conditions>
                      <delay exact="0.3s"/>
                      <actions>
                        <set_value name="$ThroneSpeech_Done"/>
                        <start_conversation actor="$ExpeditionLeaderActor" conversation="gs2_intro_convo" missioncue="$MissionCue"/>
                      </actions>
                    </cue>
                  </cues>
                </cue>

                <!-- ALI Speech & Conversation -->
                <cue name="Ch2_Ali_Speech">
                  <cues>
                    <cue name="Ch2_Ali_Speech_Conver" instantiate="true">
                      <conditions>
                        <event_conversation_started actor="$ExpeditionLeaderActor"/>
                        <check_value value="$ThroneSpeech_Done?"/>
                        <check_value value="not $AliConv_gsIntro?"/>
                      </conditions>
                      <actions>
                        <allow_conversation_escape enabled="false"/>
                        <add_npc_line speaker="$ExpeditionLeaderActor" hidechoices="true">
                          <text line="30291020" comment="readtext.{10359}.{30291020} (QuickLookup)" delay="2s"/>
                          <text line="30291021" comment="readtext.{10359}.{30291021} (QuickLookup)"/>
                        </add_npc_line>
                      </actions>
                    </cue>

                    <cue name="Ch2_Ali_IntroDone">
                      <conditions>
                        <event_conversation_finished actor="$ExpeditionLeaderActor"/>
                      </conditions>
                      <actions>
                        <set_value name="$AliConv_gsIntro"/>
                        <signal_cue cue="Ch2_Complete"/>
                      </actions>
                    </cue>
                  </cues>
                </cue>
              </cues>
            </cue>

            <cue name="Ch2_Complete">
              <conditions>
                <event_cue_signalled/>
              </conditions>
              <actions>
                <signal_cue cue="md.Story_Boron.Ch6_Tasks"/>
                <cancel_cue cue="Ch2_Throneroom"/>
                <cancel_cue cue="Idle_Lines"/>
                <cancel_cue cue="Setup"/>
                <cancel_cue cue="Start"/>
                
                <remove_mission cue="$MissionCue" type="completed"/>
                <write_to_logbook category="missions" faction="faction.player" title="{30291,1011}" text="{30291,1012}"/>
                <!--<activate_mission cue="md.Story_Boron.Ch6_1_BoFu_Delivery_Objective" comment="$MissionCue_Boso"/>-->
              </actions>
            </cue>

          </cues>
        </cue>

      </cues>
    </cue>
  </cues>
</mdscript>
