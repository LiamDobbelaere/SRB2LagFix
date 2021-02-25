local lastLagFixTime = 0

local function arrayToSet(array)
    local set = {}
    for _, value in ipairs(array) do set[value] = true end
    return set
end

local enemyTypes = arrayToSet{
    MT_BLUECRAWLA, MT_REDCRAWLA, MT_GFZFISH, MT_GOLDBUZZ, MT_REDBUZZ,
    MT_JETTBOMBER, MT_JETTGUNNER, MT_CRAWLACOMMANDER, MT_DETON, MT_SKIM,
    MT_TURRET, MT_POPUPTURRET, MT_SPINCUSHION, MT_CRUSHSTACEAN, MT_BANPYURA,
    MT_JETJAW, MT_SNAILER, MT_VULTURE, MT_POINTY, MT_ROBOHOOD, MT_FACESTABBER,
    MT_EGGGUARD, MT_GSNAPPER, MT_MINUS, MT_SPRINGSHELL, MT_YELLOWSHELL,
    MT_UNIDUS, MT_CANARIVORE, MT_PYREFLY, MT_PTERABYTE, MT_DRAGONBOMBER,
	MT_BUMBLEBORE, MT_PENGUINATOR
}

local function PerformLagFix()
    local mobjList = {}

    for mo in mobjs.iterate() do        
        if enemyTypes[mo.type] then
            table.insert(mobjList, mo)
        end
    end

    for _, mo in pairs(mobjList) do
        local newMo = P_SpawnMobjFromMobj(mo, 0, 0, 0, mo.type)
        newMo.momx = mo.momx
        newMo.momy = mo.momy
        newMo.momz = mo.momz
        newMo.angle = mo.angle
        newMo.rollangle = mo.rollangle
        newMo.flags = mo.flags
        newMo.flags2 = mo.flags2
        newMo.eflags = mo.eflags

        P_RemoveMobj(mo)
    end
end

local function PerformThanosSnap()
    local mobjList = {}

    for mo in mobjs.iterate() do        
        if enemyTypes[mo.type] then
            table.insert(mobjList, mo)
        end
    end

    local ind = 0
    for _, mo in pairs(mobjList) do
        if ind % 2 == 0 then
            P_RemoveMobj(mo)
        end

        ind = ind + 1
    end
end

addHook("NetVars", function(network)
    lastLagFixTime = network(lastLagFixTime)
end)

addHook("PlayerMsg", function(source, type, target, msg)
    if msg == 'fixlag' and leveltime - lastLagFixTime > 5 * TICRATE then
        PerformLagFix()
        chatprint('€Lag fix done, hope that helped!', true)

        lastLagFixTime = leveltime
    elseif msg == 'thanossnap' and IsPlayerAdmin(source) then
        PerformThanosSnap()
        chatprint('€Thanos snap! Perfectly balanced, as all things should be.', true)
    end
end)

addHook("MapLoad", function()
    lastLagFixTime = -5 * TICRATE
    chatprint('€Everyone having bad lag? Type fixlag in chat! Try not to overuse it.', true)
end)