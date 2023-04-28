$('#creatormenu').fadeOut(0);

window.addEventListener('message', function(event) {
    const action    = event.data.action;
    const shopWagons  = event.data.shopWagons;
    const myWagons = event.data.myWagons;

    if (action === "hide") {$("#creatormenu").fadeOut(1000);};
    if (action === "show") {$("#creatormenu").fadeIn(1000);};

    if (shopWagons) {
        for (const [index, table] of Object.entries(shopWagons)) {
            const wagonType = table.wagonType;
            if ($(`#page_shop .scroll-container .collapsible #${index}`).length <= 0) {
                $('#page_shop .scroll-container .collapsible').append(`
                    <li id="${index}">
                        <div class="collapsible-header col s12 panel ">
                            <div class="col s12 panel-title">
                                <h6 class="grey-text plus">${wagonType}</h6>
                            </div>
                        </div>
                        <div class="collapsible-body item-bg"></div>
                    </li>
                `);
            };
            for (const [model, wagonConfig] of Object.entries(table)) {
                if (model != 'wagonType') {
                    let modelWagon;
                    const label = wagonConfig.label;
                    const cashPrice  = wagonConfig.cashPrice;
                    const goldPrice  = wagonConfig.goldPrice;
                    $(`#page_shop .scroll-container .collapsible #${index} .collapsible-body`).append(`
                        <div id="${model}" class="col s12 panel-shop item">
                            <div class="col s6 panel-col item">
                                <h6 class="grey-text-shop title">${label}</h6>
                            </div>          
                            <div class="buy-buttons">
                                <button class="btn-small"  onclick="BuyWagon('${model}', ${cashPrice}, true)">
                                    <img src="img/money.png"><span>${cashPrice}</span>
                                </button>                                  
                                <button class="btn-small right-btn"  onclick="BuyWagon('${model}', ${goldPrice}, false)">                                                
                                    <img src="img/gold.png"><span>${goldPrice}</span>
                                </button>                                          
                            </div>
                        </div>
                    `);
                    $(`#page_shop .scroll-container .collapsible #${index} .collapsible-body #${model}`).hover(function() {                       
                        $(this).click(function() {                        
                            $(modelWagon).addClass("selected");
                            $('.selected').removeClass("selected"); 
                            modelWagon = $(this).attr('id');                       
                            $(this).addClass('selected');
                            $.post('http://oss_wagons/LoadWagon', JSON.stringify({WagonModel: $(this).attr('id')}));
                        });                       
                    }, function() {});
                };
            };
        };
        const location  = event.data.location;
        document.getElementById('shop_name').innerHTML = location;
    };
    if (myWagons) {
        $('#page_mywagons .scroll-container .collapsible').html('');
        $('.collapsible').collapsible();
        for (const [_, table] of Object.entries(myWagons)) {
            const wagonName = table.name;
            const wagonId = table.id;
            const wagonModel = table.model;
            $('#page_mywagons .scroll-container .collapsible').append(`
                <li>
                    <div id="${wagonId}" class="collapsible-header col s12 panel">
                        <div class="col s12 panel-title" onclick="Select(${wagonId})">
                            <h6 class="grey-text plus" >${wagonName}</h6>
                        </div>
                    </div>
                    <div class="collapsible-body col s12 panel-mywagon item">
                        <button class="col s4 panel-col item-mywagon" onclick="Rename(${wagonId})">Rename</button>
                        <button class="col s4 panel-col item-mywagon" onclick="Spawn(${wagonId}, '${wagonModel}', '${wagonName}')">Spawn</button>
                        <button class="col s4 panel-col item-mywagon" onclick="Sell(${wagonId}, '${wagonModel}', '${wagonName}')">Sell</button>
                    </div>
                </li>
            `);
            $(`#page_mywagons .scroll-container .collapsible #${wagonId}`).hover(function() {  
                $(this).click(function() {
                    $.post('http://oss_wagons/LoadMyWagon', JSON.stringify({ WagonId: wagonId, WagonModel: wagonModel}));
                });                         
            }, function() {});
        };
    };
});

function BuyWagon(modelW, price, isCash) {
    if (isCash) {        
        $.post('http://oss_wagons/BuyWagon', JSON.stringify({ ModelW: modelW, Cash: price, IsCash: isCash }));
    } else {
        $.post('http://oss_wagons/BuyWagon', JSON.stringify({ ModelW: modelW, Gold: price, IsCash: isCash }));
    };
};

function Select(wagonId) {
    $.post('http://oss_wagons/SelectWagon', JSON.stringify({WagonId: wagonId}));
};

function Rename(wagonId) {    
    $.post('http://oss_wagons/RenameWagon', JSON.stringify({ WagonId: wagonId}));
};

function Spawn(wagonId, wagonModel, wagonName) {    
    $.post('http://oss_wagons/SpawnInfo', JSON.stringify({ WagonId: wagonId, WagonModel: wagonModel, WagonName: wagonName }));
};

function Sell(wagonId, wagonName, wagonName) {    
    $.post('http://oss_wagons/SellWagon', JSON.stringify({ WagonId: wagonId,  WagonName: wagonName, WagonName: wagonName}));
};

function Rotate(direction) {
    let rotateWagon = direction;
    $.post('http://oss_wagons/Rotate', JSON.stringify({ RotateWagon: rotateWagon }));
};

function CloseMenu() {
    $.post('http://oss_wagons/CloseMenu');
    ResetMenu();
};

let currentPage = 'page_mywagons';
function ResetMenu() {
    $(`#${currentPage}`).hide();
    currentPage = 'page_mywagons';
    $('#page_mywagons').show();
    $('.menu-selectb.active').removeClass('active');
    $('#button-mywagons.menu-selectb').addClass('active');
};

$('.menu-selectb').on('click', function() {
    $(`#${currentPage}`).hide();
    currentPage = $(this).data('target');
    $(`#${currentPage}`).show();
    $('.menu-selectb.active').removeClass('active');
    $(this).addClass('active');
});
