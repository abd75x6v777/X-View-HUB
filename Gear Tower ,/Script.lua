-- استدعاء مكتبة WindUI لبناء الواجهات الاحترافية عبر الإنترنت
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- تعريف أحداث السيرفر (RemoteEvents) لضمان سرعة التنفيذ وتقليل تكرار الكود
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local mapManagerRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("mapManagerRemote")

-- 1. إنشاء النافذة الرئيسية للواجهة وتخصيص مظهرها
local Window = WindUI:CreateWindow({
    Title = "Gear Tower Hub",       -- عنوان الواجهة الرئيسي
    Icon = "gamepad",               -- أيقونة النافذة
    Author = "Programming Expert",   -- اسم المطور
    Folder = "GearTowerConfig",      -- المجلد المخصص لحفظ إعدادات المستخدم تلقائياً
    Size = UDim2.fromOffset(550, 420), -- أبعاد النافذة (العرض، الارتفاع)
    Theme = "Dark",                 -- المظهر الداكن والأنيق
    Transparent = true              -- تفعيل خاصية الشفافية العصرية
})

-- 2. إنشاء التبويب الرئيسي (Tab) للتنقل داخل الواجهة
local MainTab = Window:Tab({
    Title = "الميزات الرئيسية",
    Icon = "home"
})

-- 3. قسم الحصول على الأدوات (Tools Section)
local ToolsSection = MainTab:Section({
    Title = "قسم الأدوات والأسلحة"
})

-- زر الحصول على سلاح الليزر
ToolsSection:Button({
    Title = "الحصول على Hyper Laser Gun",
    Desc = "يمنحك سلاح الليزر الخارق فوراً في اللعبة",
    Callback = function()
        local args = {"claimTool", "Hyper Laser Gun"}
        mapManagerRemote:FireServer(unpack(args))
        
        -- إشعار منبثق يؤكد للمستخدم نجاح الإرسال
        WindUI:Notify({
            Title = "تم بنجاح",
            Content = "تم الحصول على Hyper Laser Gun!",
            Duration = 3
        })
    end
})

-- زر الحصول على أداة Whirlpool Slap
ToolsSection:Button({
    Title = "الحصول على Whirlpool Slap",
    Desc = "يمنحك أداة Whirlpool Slap تلقائياً",
    Callback = function()
        local args = {"claimTool", "Whirlpool Slap"}
        mapManagerRemote:FireServer(unpack(args))
        
        WindUI:Notify({
            Title = "تم بنجاح",
            Content = "تم الحصول على Whirlpool Slap!",
            Duration = 3
        })
    end
})

-- 4. قسم الإدارة والعملات (Admin & Coins Section)
local AdminSection = MainTab:Section({
    Title = "الإدارة والعملات النقدية"
})

-- زر تفعيل رتبة المود
AdminSection:Button({
    Title = "تفعيل رتبة Mod Admin",
    Desc = "تفعيل صلاحيات الـ Mod مجاناً وبدون تكلفة",
    Callback = function()
        local args = {"buyAdmin", "Mod", 0}
        mapManagerRemote:FireServer(unpack(args))
        
        WindUI:Notify({
            Title = "تم بنجاح",
            Content = "تم تفعيل رتبة المود بنجاح!",
            Duration = 3
        })
    end
})

-- زر الحصول على العملات
AdminSection:Button({
    Title = "الحصول على 8K عملة مجانية",
    Desc = "إضافة 8000 عملة نقدية إلى رصيدك باللعبة",
    Callback = function()
        local args = {"claimCoins", "8kCoinsGiver"}
        mapManagerRemote:FireServer(unpack(args))
        
        WindUI:Notify({
            Title = "تم بنجاح",
            Content = "تمت إضافة 8,000 عملة بنجاح!",
            Duration = 3
        })
    end
})

-- 5. قسم التحكم السريع المختصر (Quick Actions)
local QuickSection = MainTab:Section({
    Title = "التحكم السريع"
})

-- زر لتشغيل جميع الأوامر دفعة واحدة اختصاراً للوقت
QuickSection:Button({
    Title = "تفعيل كل الميزات معاً 🚀",
    Desc = "يقوم بإرسال كافة الأوامر السابقة دفعة واحدة تلقائياً بالترتيب",
    Callback = function()
        mapManagerRemote:FireServer(unpack({"claimTool", "Hyper Laser Gun"}))
        task.wait(0.1) -- فترات انتظار قصيرة جداً لمنع الضغط العالي على السيرفر
        mapManagerRemote:FireServer(unpack({"claimTool", "Whirlpool Slap"}))
        task.wait(0.1)
        mapManagerRemote:FireServer(unpack({"buyAdmin", "Mod", 0}))
        task.wait(0.1)
        mapManagerRemote:FireServer(unpack({"claimCoins", "8kCoinsGiver"}))
        
        WindUI:Notify({
            Title = "نجاح شامل",
            Content = "تم تفعيل جميع الأدوات والعملات معاً بنجاح!",
            Duration = 4
        })
    end
})
