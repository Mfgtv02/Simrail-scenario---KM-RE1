-- SimRail - The Railway Simulator
-- LUA Scripting scenario
-- Version: 1.0

require("SimRailCore")

---Used only to enable developer mode
DeveloperMode = function()
    return true
end

--- Player start position as Vector3
StartPosition = {128477.20, 92.58, 225552.70}
--- List of sounds with their keys
Sounds = {}
Trains = {}

--- Function to prepare the scenario
function PrepareScenario()
    Log("Scenario preparation started.")
end

--- Function to handle early start logic
function EarlyStartScenario()
    Log("Early start scenario logic executed.")
end

--- Function to start the scenario
function StartScenario()
    CreateCoroutine(function()
        ShowMessageBox("#M_Weather", {
                ["Text"] = "#Sunny_Summer",
                ["OnClick"] = function()
                    SetStartDateTime(DateTimeCreate(2024, 06, 11, 8, 14, 00))
                    SetWeather(WeatherConditionCode.ScatteredClouds, 20, 1000, 70, 3500, 10, 5, 5, true)
                    Weather = 0
                    Log("Weather set to Sunny Summer.")
                end,
            }, {
                ["Text"] = "#Rainy_Autumn",
                ["OnClick"] = function()
                    SetStartDateTime(DateTimeCreate(2024, 10, 28, 8, 14, 00))
                    SetWeather(WeatherConditionCode.ModerateRain, 10, 1000, 70, 1500, 10, 5, 5, true)
                    Weather = 1
                    Log("Weather set to Rainy Autumn.")
                end,
            }, {
                ["Text"] = "#Snowy_Winter",
                ["OnClick"] = function()
                    SetStartDateTime(DateTimeCreate(2024, 12, 28, 8, 14, 00))
                    SetWeather(WeatherConditionCode.Snow, -10, 1000, 70, 1000, 10, 5, 5, true)
                    Weather = 2
                    Log("Weather set to Snowy Winter.")
                end,
            }
        )
        coroutine.yield(CoroutineYields.WaitForSeconds, 1)

        Trains[0] = SpawnTrainsetOnSignal("player", FindSignal("WSD_Tm81"), 30, false, true, false, true, {
            CreateNewSpawnVehicleDescriptor(LocomotiveNames.EN76_022, false)
        })
        if Trains[0] then
            Log("Player train spawned and configured.")
            Trains[0].SetTimetable(LoadTimetableFromFile("timetable.xml"), false)
            Trains[0].SetRadioChannel(2, true)
        else
            Log("Failed to spawn player train.")
        end

        coroutine.yield(CoroutineYields.WaitForSeconds, 3)

        Log("Scenario step: " .. ScenarioStep)
    end)


---sygnal wyjazdowy ze wschodniej
    CreateSignalTrigger(FindSignal("WSD_J10"), 300, {
        check = UnconditialCheck,
        result = function(e)
            CreateCoroutine(function()
                coroutine.yield(CoroutineYields.WaitForTrainsetPassengerExchangeFinished, RailstockGetPlayerTrainset(), TimeSpanCreate(0, 0, 0, 20, 0))
                VDSetRouteWithVariant("WSD_J10", "WSD_Akps", VDOrderType.TrainRoute, {
                    GetMidPointVariant("WSD_12cd", true),
                    GetMidPointVariant("WSD_12ab", false),
                    GetMidPointVariant("WSD_7cd", true),
                    GetMidPointVariant("WSD_7ab", true),
                    GetMidPointVariant("WSD_5", false),
                    GetMidPointVariant("WSD_3", false),
                    GetMidPointVariant("WSD_2", false),
                    GetMidPointVariant("z1333", true)
                })                
                coroutine.yield(CoroutineYields.WaitForSeconds, 17)
                DisplayChatText("0")
            end)
        end
    })

---sygnal wjazdowy na centralna
    CreateSignalTrigger(FindSignal("WDC_W"), 1500, {
        check = UnconditialCheck,
        result = function(e)
            CreateCoroutine(function()
                VDSetRoute("WDC_W", "WDC_H", VDOrderType.TrainRoute)
            end)
        end
    })

---sygnal wyjazdowy centralna
CreateSignalTrigger(FindSignal("WDC_H"), 1500, {
    check = UnconditialCheck,
    result = function(e)
        CreateCoroutine(function()
            coroutine.yield(CoroutineYields.WaitForTrainsetPassengerExchangeFinished, RailstockGetPlayerTrainset(), TimeSpanCreate(0, 0, 0, 30, 0))
            DisplayChatText("3")   
            coroutine.yield(CoroutineYields.WaitForSeconds, 5)
            DisplayChatText("4")
            coroutine.yield(CoroutineYields.WaitForSeconds, 20)
            DisplayChatText("0")
            VDSetRoute("WDC_H", "WDC_Akps", VDOrderType.TrainRoute)
        end)
    end
})

---sygnal wyjazdowy zachodnia
CreateSignalTrigger(FindSignal("WZD_J23"), 1500, {
    check = UnconditialCheck,
    result = function(e)
        CreateCoroutine(function()
            coroutine.yield(CoroutineYields.WaitForTrainsetPassengerExchangeFinished, RailstockGetPlayerTrainset(), TimeSpanCreate(0, 0, 0, 10, 0))
            VDSetRoute("WZD_J23", "WZD_Okps", VDOrderType.TrainRoute)
            coroutine.yield(CoroutineYields.WaitForSeconds, 7)
            DisplayChatText("0")
        end)
    end
})

---sygnal wjazdowy wlochy
CreateSignalTrigger(FindSignal("Wl_C"), 2000, {
    check = UnconditialCheck,
    result = function(e)
        CreateCoroutine(function()
            VDSetRoute("Wl_C", "Wl_M", VDOrderType.TrainRoute)
        end)
    end
})

---sygnal wyjazdowy wlochy
CreateSignalTrigger(FindSignal("Wl_M"), 150, {
    check = UnconditialCheck,
    result = function(e)
        CreateCoroutine(function()
            coroutine.yield(CoroutineYields.WaitForTrainsetPassengerExchangeFinished, RailstockGetPlayerTrainset(), TimeSpanCreate(0, 0, 0, 15, 0))
            VDSetRoute("Wl_M", "Wl_Tkps", VDOrderType.TrainRoute)
            coroutine.yield(CoroutineYields.WaitForSeconds, 13)
            DisplayChatText("0")
        end)
    end
})

---wyjazd ursus
CreateSignalTrigger(FindSignal("L447_101"), 1000, {
    check = UnconditialCheck,
    result = function(e)
        CreateCoroutine(function()
            coroutine.yield(CoroutineYields.WaitForTrainsetPassengerExchangeFinished, RailstockGetPlayerTrainset(), TimeSpanCreate(0, 0, 0, 2, 0))
            DisplayChatText("0")
        end)
    end
})

---wyjazd ursus niedzwiadek
CreateSignalTrigger(FindSignal("L447_117"), 1250, {
    check = UnconditialCheck,
    result = function(e)
        CreateCoroutine(function()
            coroutine.yield(CoroutineYields.WaitForTrainsetPassengerExchangeFinished, RailstockGetPlayerTrainset(), TimeSpanCreate(0, 0, 0, 2, 0))
            DisplayChatText("0")
        end)
    end
})

---wyjazd piastow
CreateSignalTrigger(FindSignal("L447_127"), 330, {
    check = UnconditialCheck,
    result = function(e)
        CreateCoroutine(function()
            coroutine.yield(CoroutineYields.WaitForTrainsetPassengerExchangeFinished, RailstockGetPlayerTrainset(), TimeSpanCreate(0, 0, 0, 2, 0))
            DisplayChatText("0")
        end)
    end
})

---sygnal wjazdowy pruszkow
CreateSignalTrigger(FindSignal("Pr_B"), 1500, {
    check = UnconditialCheck,
    result = function(e)
        CreateCoroutine(function()
            VDSetRouteWithVariant("Pr_B", "Pr_L3", VDOrderType.TrainRoute, {
                GetMidPointVariant("Pr_3", false),
                GetMidPointVariant("Pr_4", true),
                GetMidPointVariant("Pr_6", true),
                GetMidPointVariant("Pr_7", true),
                GetMidPointVariant("Pr_10", true),
                GetMidPointVariant("Pr_11", false),
                GetMidPointVariant("Pr_21", false)
            })
        end)
    end
})

---wyjazd pruszkow
CreateSignalTrigger(FindSignal("Pr_Tm21"), 160, {
    check = UnconditialCheck,
    result = function(e)
        CreateCoroutine(function()
            coroutine.yield(CoroutineYields.WaitForTrainsetPassengerExchangeFinished, RailstockGetPlayerTrainset(), TimeSpanCreate(0, 0, 0, 2, 0))
            DisplayChatText("0")
        end)
    end
})

---sygnal wjazdowy parzniew
CreateSignalTrigger(FindSignal("Pr_L3"), 1500, {
    check = UnconditialCheck,
    result = function(e)
        CreateCoroutine(function()
            VDSetRoute("Pr_L3", "Pr_Wkps", VDOrderType.TrainRoute)
        end)
    end
})

---wyjazd z parzniewa i rozkaz o zmieniejszenie predkosci do brwinowa todo
CreateSignalTrigger(FindSignal("L447_193"), 750, {
    check = UnconditialCheck,
    result = function(e)
        CreateCoroutine(function()
            coroutine.yield(CoroutineYields.WaitForTrainsetPassengerExchangeFinished, RailstockGetPlayerTrainset(), TimeSpanCreate(0, 0, 0, 30, 0))
            DisplayChatText("bedziemy jechac z mniejsza predkoscia do brwinowa z powodu zmniejszonej predkosci, zaraz podyktuje rozkaz")  
            coroutine.yield(CoroutineYields.WaitForSeconds, 10)     
            DisplayChatText("rozkaz")
            coroutine.yield(CoroutineYields.WaitForSeconds, 5)  
            DisplayChatText("przyjalem")
            coroutine.yield(CoroutineYields.WaitForSeconds, 13)  
            DisplayChatText("0")
        end)
    end
})

---wyjazd z brwinowa
CreateSignalTrigger(FindSignal("L447_223"), 210, {
    check = UnconditialCheck,
    result = function(e)
        CreateCoroutine(function()
            coroutine.yield(CoroutineYields.WaitForTrainsetPassengerExchangeFinished, RailstockGetPlayerTrainset(), TimeSpanCreate(0, 0, 0, 2, 0))
            DisplayChatText("0")
        end)
    end
})

---wyjazd z milanowka
CreateSignalTrigger(FindSignal("L447_271"), 1050, {
    check = UnconditialCheck,
    result = function(e)
        CreateCoroutine(function()
            coroutine.yield(CoroutineYields.WaitForTrainsetPassengerExchangeFinished, RailstockGetPlayerTrainset(), TimeSpanCreate(0, 0, 0, 2, 0))
            DisplayChatText("0")
        end)
    end
})

---wjazd do grodziska
CreateSignalTrigger(FindSignal("Gr_B"), 2000, {
    check = UnconditialCheck,
    result = function(e)
        CreateCoroutine(function()
            VDSetRouteWithVariant("Gr_B", "Gr_M3", VDOrderType.TrainRoute, {
                GetMidPointVariant("Gr_2", false),
                GetMidPointVariant("Gr_4", true),
                GetMidPointVariant("Gr_6", true),
                GetMidPointVariant("Gr_7", false),
                GetMidPointVariant("Gr_9", true),
                GetMidPointVariant("Gr_13", true),
                GetMidPointVariant("Gr_14", true),
                GetMidPointVariant("Gr_17", true),
                GetMidPointVariant("Gr_19", false)
            })
        end)
    end
})


---sygnal wyjazdowy z grodziska do manewrów
CreateSignalTrigger(FindSignal("Gr_M3"), 260, {
    check = UnconditialCheck,
    result = function(e)
        CreateCoroutine(function()
            coroutine.yield(CoroutineYields.WaitForTrainsetPassengerExchangeFinished, RailstockGetPlayerTrainset(), TimeSpanCreate(0, 0, 0, 30, 0))
            DisplayChatText("7")     
            coroutine.yield(CoroutineYields.WaitForSeconds, 5)
            DisplayChatText("8")
            coroutine.yield(CoroutineYields.WaitForSeconds, 23)      
            DisplayChatText("0")
        end)
    end
})




end





---Wylapywanie zew3 i podawanie po tym semafora
function OnPlayerRadioCall(trainsetInfo, radio_SelectionCall)
    Log("Call pressed in " .. trainsetInfo.name .. ". Call type: " .. tostring(radio_SelectionCall))
    if(ScenarioStep == "VDStart") then
        CreateCoroutine(function ()
            DisplayChatText("1")
            coroutine.yield(CoroutineYields.WaitForSeconds, 5)
            DisplayChatText("2")
            coroutine.yield(CoroutineYields.WaitForSeconds, 10)
            VDSetRoute("WSD_Tm81", "WSD_J10", VDOrderType.ManeuverRoute)
            Log("Finished scenario step: " .. ScenarioStep)
            ScenarioStep = "Wwaw_Start"
            Log("started Scenario step: " .. ScenarioStep)
        end)
---sygnal wjazdowy zachodnia
    if(ScenarioStep == "Wwaw_Start") then
        CreateCoroutine(function ()
            DisplayChatText("5")       
            coroutine.yield(CoroutineYields.WaitForSeconds, 5)
            DisplayChatText("6")
            coroutine.yield(CoroutineYields.WaitForSeconds, 8)      
            VDSetRoute("WZD_C", "WZD_J23", VDOrderType.TrainRoute)                    
            Log("Finished scenario step: " .. ScenarioStep)
            ScenarioStep = "Wwaw_zachodnia"
            Log("started Scenario step: " .. ScenarioStep)           
        end)        
    end
    end

end

---cos do trigerow xD
function UnconditialCheck(e)
    return true
end

function PerformUpdate()

end

--- VD gotowosc
function OnVirtualDispatcherReady()
    ScenarioStep = "VDStart"
    Log("Virtual Dispatcher is ready!")
    Log("started Scenario step: " .. ScenarioStep)
end