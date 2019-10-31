<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>欢迎页面-L-admin1.0</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width,user-scalable=yes, minimum-scale=0.4, initial-scale=0.8,target-densitydpi=low-dpi" />
    <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />
    <link rel="stylesheet" href="../css/font.css">
    <link rel="stylesheet" href="../css/xadmin.css">
    <script src="../js/jquery.min.js"></script>
    <script type="text/javascript" src="../lib/layui/layui.js" charset="utf-8"></script>
    <script type="text/javascript" src="../js/xadmin.js"></script>
    <!-- 让IE8/9支持媒体查询，从而兼容栅格 -->
    <!--[if lt IE 9]>
      <script src="https://cdn.staticfile.org/html5shiv/r29/html5.min.js"></script>
      <script src="https://cdn.staticfile.org/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
  </style>
  <body>
    <div class="x-body">
      <xblock>
        <button class="layui-btn" onclick="ckkk('添加用户','tokenfilter/menumanage_upad.jsp')"><i class="layui-icon"></i>添加</button>
       
      </xblock>
      <table class="layui-table">
        <thead>
          <tr>
            <th></th>
            <th>菜单名称</th>
            <th>路径</th>
            <th>类型</th>
            <th>状态</th>
            <th>操作</th>
        </thead>
        <tbody id="tbody">
          
        </tbody>
      </table>
      <div id="demo6" style="text-align: center;"></div>

    </div>
    <script type="text/javascript">
    var fyy;
	var fyycount;
	$(function(){
		all();
		$("#count").text("共有数据："+fyycount+" 条");
	})
  	//初始页面
	function all(){
		$.ajax({
			url : 'jurisdictionActionfindByJurisdiction.action',
			type : 'post',
			async : false,
			success : function(data) {
				var all = eval(data);
				fyy=all;
				fyycount=all.length;
				sxfy();
			}
		});
	}
	function ckkk(title,url,id){
		var url=url+"?id="+id;
		 var index = layui.layer.open({
		        title : title,
		        type : 2,
		        content : url,//弹出层页面
		        area: ['800px', '500px'],
		        shadeClose: true,
		        maxmin: true,
		        fix: false, //不固定
		        end: function () {
		            location.reload();
		          }
		    })
	}
	//分页方法
	function sxfy() {
		layui.use([ 'laypage', 'layer' ], function() {
			var laypage = layui.laypage, layer = layui.layer;

			//只显示上一页、下一页
			laypage.render({
				elem : 'demo6',
				count : fyycount,
				layout : [ 'prev', 'next' ],
				jump : function(obj, first) {
					if (!first) {
						layer.msg('第 ' + obj.curr + ' 页');
					}
				}
			});

			//将一段数组分页展示

			//调用分页
			laypage.render({
				elem : 'demo6',
				count : fyycount,
				limit : 6,
				jump : function(obj) {
					//模拟渲染
					document.getElementById('tbody').innerHTML = function() {
						var arr = [], thisData = fyy.concat()
								.splice(obj.curr * obj.limit - obj.limit,
										obj.limit);
						layui.each(thisData, function(index, item) {
							var url="";
							var lx="菜单";
							var ico="'停用'><i style='color:limegreen' class='layui-icon'>&#xe601;</i>";
							var state="<span class='layui-btn layui-btn-normal layui-btn-mini'>已启用</span>"; 
							if(item.url!=null&&item.url!=""){
								url=item.url;
								lx="子菜单";
							}
							if(item.state!=0){
								state="<span class='layui-btn layui-btn-normal layui-btn-mini layui-btn-disabled'>已停用</span>";
								ico="'启用'><i style='color:limegreen' class='layui-icon'>&#xe62f;</i>";
							} 
							arr.push('<tr>' + '<td>'
									+ (parseInt(index) + 1) +'</td>'
									+ '<td>' + item.jname + '</td>'
									+ '<td>' +url
								     + '</td>' + '<td>'
									+ lx + '</td>'
									+'<td class="td-status">'+state+'</td>'
						             +'<td class="td-manage">'
						              +"<a "
						              +'onclick='
						              +'member_stop(this,'+item.jid+') href="javascript:;" title='
						              	+ico
						              +'</a>'
						              +"<a title='编辑'  "
						              +'onclick='
						              +"ckkk('修改权限','tokenfilter/menumanage_upad.jsp',"+item.jid+') href="javascript:;">'
						                +'<i style="color:limegreen" class="layui-icon">&#xe642;</i></a></td></tr>');
							
						});
						
						return arr.join('');
					}();
				}
			});

		});
	}
      layui.use('laydate', function(){
        var laydate = layui.laydate;
        
        //执行一个laydate实例
        laydate.render({
          elem: '#start' //指定元素
        });

        //执行一个laydate实例
        laydate.render({
          elem: '#end' //指定元素
        });
      });

       /*用户-停用*/
      function member_stop(obj,id){
    	  var t=$(obj).attr('title');
          layer.confirm('确认要'+t+'吗？',function(index){
              if($(obj).attr('title')!='启用'){
            	  $.ajax({
          			url : 'jurisdictionActionupJurisdictionByState.action',
          			type : 'post',
          			async : false,
          			data:{
          				"id":id,
          				"state":1
          			},
          			success : function(data) {
          				var all = eval(data);
          				if(all>0){
          				//发异步把用户状态进行更改
          	                $(obj).attr('title','启用')
          	                $(obj).find('i').html('&#xe62f;');
          	                $(obj).parents("tr").find(".td-status").find('span').addClass('layui-btn-disabled').html('已停用');
          	                layer.msg('已停用!',{icon: 5,time:1000});
          				}else{
          					layer.msg('停用失败!',{icon: 5,time:1000});
          				}
          				this.load();
          			}
          			});

              }else{
            	  $.ajax({
            			url : 'jurisdictionActionupJurisdictionByState.action',
            			type : 'post',
            			async : false,
            			data:{
            				"id":id,
            				"state":0
            			},
            			success : function(data) {
            				var all = eval(data);
            				if(all>0){
            				//发异步把用户状态进行更改
            					$(obj).attr('title','停用')
            	                $(obj).find('i').html('&#xe601;');
            	                $(obj).parents("tr").find(".td-status").find('span').removeClass('layui-btn-disabled').html('已启用');
            	                layer.msg('已启用!',{icon: 5,time:1000});
            				}else{
            					layer.msg('启用失败!',{icon: 5,time:1000});
            				}
            			}
            			});
                
              }
              
          });
      }

    </script>
  </body>

</html>