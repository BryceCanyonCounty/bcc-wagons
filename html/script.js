$('#creatormenu').fadeOut(0);

window.addEventListener('message', function(event) {
    const action    = event.data.action;
    const shopData  = event.data.shopData;
    const wagonData = event.data.myWagonsData;

    if (action === "hide") {$("#creatormenu").fadeOut(1000);};
    if (action === "show") {$("#creatormenu").fadeIn(1000);};

    if (shopData) {
        for (const [index, table] of Object.entries(shopData)) {
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
            for (const [_, wagonData] of Object.entries(table)) {
                if (_ != 'wagonType') {
                    let ModelWagon;
                    const wagonLabel = wagonData.label;
                    const priceCash  = wagonData.cashPrice;
                    const priceGold  = wagonData.goldPrice;
                    $(`#page_shop .scroll-container .collapsible #${index} .collapsible-body`).append(`
                        <div id="${_}" onhover="loadWagon(this)" class="col s12 panel-shop item">
                            <div class="col s6 panel-col item">
                                <h6 class="grey-text-shop title">${wagonLabel}</h6>
                            </div>          
                            <div class="buy-buttons">
                                <button class="btn-small"  onclick="BuyWagon('${_}', ${priceCash}, true)">
                                    <img src="img/money.png"><span class="wagon-price">${priceCash}</span>
                                </button>                                  
                                <button class="btn-small right-btn"  onclick="BuyWagon('${_}', ${priceGold}, false)">                                                
                                    <img src="img/gold.png"><span class="wagon-price">${priceGold}</span>
                                </button>                                          
                            </div>
                        </div>
                    `);
                    $(`#page_shop .scroll-container .collapsible #${index} .collapsible-body #${_}`).hover(function() {                       
                        $(this).click(function() {                        
                            $(ModelWagon).addClass("selected");
                            $('.selected').removeClass("selected"); 
                            ModelWagon = $(this).attr('id');                       
                            $(this).addClass('selected');
                            $.post('http://oss_wagons/LoadWagon', JSON.stringify({wagonModel: $(this).attr('id')}));
                        });                       
                    }, function() {});
                };
            };
        };
        const location  = event.data.location;
        document.getElementById('shop_name').innerHTML = location;
    };
    if (wagonData) {
        $('#page_mywagons .scroll-container .collapsible').html('');
        $('.collapsible').collapsible();
        for (const [ind, tab] of Object.entries(wagonData)) {
            const wagonName = tab.name;
            const wagonId = tab.id;
            const wagonModel = tab.model;
            $('#page_mywagons .scroll-container .collapsible').append(`
                <li>
                    <div id="${wagonId}" class="collapsible-header col s12 panel">
                        <div class="col s12 panel-title">
                            <h6 class="grey-text plus" onclick="Select(${wagonId})">${wagonName}</h6>
                        </div>
                    </div>
                    <div class="collapsible-body col s12 panel-mywagon item">
                        <button class="col s4 panel-col item-mywagon" onclick="Rename(${wagonId})">Rename</button>
                        <button class="col s4 panel-col item-mywagon" onclick="Spawn(${wagonId}, '${wagonModel}', '${wagonName}')">Spawn</button>
                        <button class="col s4 panel-col item-mywagon" onclick="Sell(${wagonId}, '${wagonModel}')">Sell</button>
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
    $('#page_mywagons .scroll-container .collapsible').html('');
    $('#page_shop .scroll-container .collapsible').html('');
    $("#creatormenu").fadeOut(1000);
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
    $('#page_mywagons .scroll-container .collapsible').html('');
    $('#page_shop .scroll-container .collapsible').html('');
    $("#creatormenu").fadeOut(1000);
};

function Spawn(wagonId, wagonModel, wagonName) {    
    $.post('http://oss_wagons/SetWagonInfo', JSON.stringify({ WagonId: wagonId, WagonModel: wagonModel, WagonName: wagonName }));
    $('#page_mywagons .scroll-container .collapsible').html('');
    $('#page_shop .scroll-container .collapsible').html('');
    $("#creatormenu").fadeOut(1000);
    CloseMenu()
};

function Sell(wagonId, wagonName) {    
    $.post('http://oss_wagons/SellWagon', JSON.stringify({ WagonId: wagonId,  WagonName: wagonName}));
    $('#page_mywagons .scroll-container .collapsible').html('');
    $('#page_shop .scroll-container .collapsible').html('');
    $("#creatormenu").fadeOut(1000);
};

function Rotate(direction) {
    let rotateWagon = direction;
    $.post('http://oss_wagons/Rotate', JSON.stringify({ RotateWagon: rotateWagon }));
};

function CloseMenu() {
    $.post('http://oss_wagons/CloseMenu');
    $('#page_mywagons .scroll-container .collapsible').html('');
    $('#page_shop .scroll-container .collapsible').html('');
    $("#creatormenu").fadeOut(1000);
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
