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
                Log("Wyjazd z wsd podany")
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
            DisplayChatText("Dyzurny: 19962 do zachodniej będziemy jechać na zatępczy z powodu awarii urządzeń sterujacych")   
            coroutine.yield(CoroutineYields.WaitForSeconds, 5)
            DisplayChatText("19962: Zrozumiano")
            coroutine.yield(CoroutineYields.WaitForSeconds, 20)
            VDSetRoute("WDC_H", "WDC_Akps", VDOrderType.Substitute)
        end)
    end
})


end

---Wylapywanie zew3 i podawanie po tym semafora
function OnPlayerRadioCall(trainsetInfo, radio_SelectionCall)
    Log("Call pressed in " .. trainsetInfo.name .. ". Call type: " .. tostring(radio_SelectionCall))
    if(ScenarioStep == "VDStart") then
        CreateCoroutine(function ()
            DisplayChatText("19962: Pociąg 19962 gotowy do manewrów w perony")
            coroutine.yield(CoroutineYields.WaitForSeconds, 5)
            DisplayChatText("Dyzurny: 19962 tarcza manewrowa podana")
            coroutine.yield(CoroutineYields.WaitForSeconds, 10)
            VDSetRoute("WSD_Tm81", "WSD_J10", VDOrderType.ManeuverRoute)
            Log("Finished scenario step: " .. ScenarioStep)
            ScenarioStep = "Wwaw_Start"
            Log("started Scenario step: " .. ScenarioStep)
        end)
    end
end



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